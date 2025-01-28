package repository

import (
	"context"
	"log"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"hm.barney-host.site/internals/features/chat/dto"
)

type MessageRepository interface {
	InsertMessage(ctx context.Context, senderId, roomId, message string) (time.Time, error)
	InsertMemeberToRoom(ctx context.Context, userId, roomId string) error
	InsertJobRoom(ctx context.Context, jobId string, name string) (string, error)
	GetMessagesByRoomId(ctx context.Context, roomId string) (*[]dto.Message, error)
	UpdateOnlineStatus(ctx context.Context, userId string, status bool) error
	GetRoomIdsOfUserById(ctx context.Context, userId string) ([]string, error)
	GetMembersOfRoomByRoomId(ctx context.Context, roomId string) (*[]dto.MemberInRoom, error)
	GetRoomsByUserId(ctx context.Context, userId string) (*[]dto.Room, error)
	JobChatRoomExists(ctx context.Context, jobId string) (bool, error)
	GetRoomIdByJobId(ctx context.Context, jobId string) (string, error)
}
type Message struct {
	pool *pgxpool.Pool
}

func NewMessageRepository(pool *pgxpool.Pool) *Message {
	return &Message{pool}
}
func (m *Message) InsertMessage(
	ctx context.Context,
	senderId, roomdId, message string,
) (time.Time, error) {
	cmd := `INSERT INTO group_messages(chat_room_id, sender_id, message)
			VALUES ($1, $2, $3) RETURNING created_at
		   `
	args := []any{
		roomdId,
		senderId,
		message,
	}
	var on time.Time
	err := m.pool.QueryRow(ctx, cmd, args...).Scan(&on)
	if err != nil {
		return time.Time{}, err
	}
	return on, nil
}

func (m *Message) GetMessagesByRoomId(
	ctx context.Context,
	roomId string,
) (*[]dto.Message, error) {
	query := `
		SELECT 
			u.profile_pic_url AS sender_profile,
			u.id AS sender_id,
			gm.chat_room_id AS room_id,
			gm.created_at AS sent_time,
			gm.is_seen,
			gm.message 
		FROM 
			group_messages gm
		JOIN 
			users u ON gm.sender_id = u.id
		JOIN 
			job_chat_members jcm ON gm.chat_room_id = jcm.chat_room_id
		WHERE 
			gm.chat_room_id = $1 
		`
	rows, err := m.pool.Query(ctx, query, roomId)
	defer rows.Close()
	if err != nil {
		return nil, err
	}
	var messagesDto []dto.Message
	for rows.Next() {
		var messageDto dto.Message
		err := rows.Scan(
			&messageDto.SenderProfileIcon,
			&messageDto.SenderId,
			&messageDto.RoomId,
			&messageDto.SentTime,
			&messageDto.IsSeen,
			&messageDto.Message,
		)
		if err != nil {
			return &[]dto.Message{}, err
		}
		messagesDto = append(messagesDto, messageDto)
	}
	return &messagesDto, nil
}

func (m *Message) GetRoomsByUserId(ctx context.Context, userId string) (*[]dto.Room, error) {
	query := `
		WITH LatestMessages AS (
		SELECT 
			chat_room_id,
			message,
			created_at,
			ROW_NUMBER() OVER (PARTITION BY chat_room_id ORDER BY created_at DESC) AS rn
		FROM 
			group_messages
		)
		SELECT 
			job_chat_rooms.id AS chat_room_id
			org_jobs.id AS job_id, 
			lm.message AS latest_message,
			lm.created_at AS sent_time,
			profile_icon, 
			organization_name
		FROM 
			organizations 
		JOIN 
			org_jobs ON org_jobs.org_id = organizations.id 
		LEFT JOIN 
			job_chat_rooms ON job_chat_rooms.job_id = org_jobs.id
		LEFT JOIN 
			LatestMessages lm ON lm.chat_room_id = job_chat_rooms.id AND lm.rn = 1
		JOIN 
			job_chat_members jcm ON jcm.chat_room_id = job_chat_rooms.id
		WHERE 
			jcm.user_id = $1;  
	`
	rows, err := m.pool.Query(
		ctx,
		query,
		userId,
	)

	defer rows.Close()

	var roomsDto []dto.Room
	for rows.Next() {
		var roomDto dto.Room
		err := rows.Scan(
			&roomDto.RoomId,
			&roomDto.JobId,
			&roomDto.LatestText,
			&roomDto.SentTime,
			&roomDto.RoomProfile,
			&roomDto.RoomName,
		)
		if err != nil {
			return &[]dto.Room{}, err
		}
		roomsDto = append(roomsDto, roomDto)
	}
	if err != nil {
		return &[]dto.Room{}, err
	}
	return &roomsDto, nil
}

func (m *Message) UpdateOnlineStatus(ctx context.Context, userId string, status bool) error {
	cmd := `UPDATE users SET is_online = $1 WHERE id = $2`
	_, err := m.pool.Exec(ctx, cmd, status, userId)
	if err != nil {
		log.Println(err)
		return err
	}
	return nil
}

func (m *Message) GetRoomIdsOfUserById(ctx context.Context, userId string) ([]string, error) {
	query := `SELECT job_chat_rooms.id from job_chat_rooms
	          JOIN job_chat_members ON job_chat_rooms.id = job_chat_members.chat_room_id
			  WHERE user_id = $1`
	rows, err := m.pool.Query(ctx, query, userId)
	defer rows.Close()
	if err != nil {
		return []string{}, err
	}
	var roomIds []string
	for rows.Next() {
		var roomId string
		err := rows.Scan(&roomId)
		if err != nil {
			return []string{}, err
		}
		roomIds = append(roomIds, roomId)
	}

	return roomIds, nil
}

func (m *Message) GetMembersOfRoomByRoomId(ctx context.Context, roomId string) (*[]dto.MemberInRoom, error) {
	query := `SELECT job_chat_members.user_id, job_chat_members.joined_at,
			  users.profile_pic_url, users.name users.username, users.role,
			  users.is_online  FROM job_chat_members JOIN users ON users.id = job_chat_members.user_id
			  WHERE job_chat_members.chat_room_id = $1 ORDER BY job_chat_members.joined_at ASC`
	rows, err := m.pool.Query(ctx, query, roomId)
	defer rows.Close()

	if err != nil {
		return &[]dto.MemberInRoom{}, err
	}
	var members []dto.MemberInRoom
	for rows.Next() {
		var member dto.MemberInRoom
		err := rows.Scan(
			&member.UserId,
			&member.JoinedAt,
			&member.UserProfileIcon,
			&member.Name,
			&member.Username,
			&member.Role,
			&member.OnlineStatus,
		)
		if err != nil {
			return &[]dto.MemberInRoom{}, err
		}
		members = append(members, member)
	}
	return &members, nil
}

func (c *Message) InsertJobRoom(ctx context.Context, jobId, roomName string) (string, error) {
	jobRoomId := ""
	cmd := `INSERT INTO job_chat_rooms(job_id, name) VALUES ($1, $2) RETURNING id`
	err := c.pool.QueryRow(ctx, cmd, jobId, roomName).Scan(&jobRoomId)
	if err != nil {
		return "", err
	}
	return jobRoomId, nil
}

func (c *Message) JobChatRoomExists(ctx context.Context, jobId string) (bool, error) {
	query := `SELECT EXISTS(SELECT 1 FROM job_chat_rooms WHERE job_id = $1)`
	var exists bool
	err := c.pool.QueryRow(ctx, query, jobId).Scan(&exists)
	if err != nil {
		return false, err
	}
	return exists, nil
}

func (c *Message) InsertMemeberToRoom(ctx context.Context, userId, roomId string) error {
	cmd := `INSERT INTO job_chat_members(user_id, chat_room_id) VALUES ($1, $2)`
	_, err := c.pool.Exec(ctx, cmd, userId, roomId)
	return err
}

func (m *Message) GetRoomIdByJobId(ctx context.Context, jobId string) (string, error) {
	var roomId string
	query := `SELECT id FROM job_chat_rooms WHERE job_id = $1`
	err := m.pool.QueryRow(ctx, query, jobId).Scan(&roomId)
	if err != nil {
		return "", err
	}
	return roomId, nil
}
