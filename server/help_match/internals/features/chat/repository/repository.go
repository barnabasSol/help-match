package repository

import (
	"context"
	"time"

	"github.com/go-redis/redis/v8"
	"github.com/jackc/pgx/v5/pgxpool"
	"hm.barney-host.site/internals/features/chat/dto"
)

type MessageRepository interface {
	InsertMessage(ctx context.Context, senderId, roomId, message string, sentTIme time.Time) error
	InsertMemeberToRoom(ctx context.Context, isOrg bool, userId, roomId string) error
	InsertJobRoom(ctx context.Context, jobId string, name string) (string, error)
	GetMessagesByRoomId(ctx context.Context, roomId string) (*[]dto.Message, error)
	GetRoomIdsOfUserById(ctx context.Context, userId string) ([]string, error)
	GetRoomIdByJobId(ctx context.Context, jobId string) (string, error)
	GetMembersOfRoomByRoomId(ctx context.Context, roomId string) (*[]dto.MemberInRoom, error)
	GetRoomsByUserId(ctx context.Context, userId string) (*[]dto.Room, error)
	UpdateOnlineStatus(ctx context.Context, userId string, status bool) error
	JobChatRoomExists(ctx context.Context, jobId string) (bool, error)
}
type Message struct {
	pool        *pgxpool.Pool
	redisClient *redis.Client
}

func NewMessageRepository(pool *pgxpool.Pool, redis *redis.Client) *Message {
	return &Message{pool, redis}
}

func (m *Message) InsertMessage(
	ctx context.Context,
	senderId, roomdId, message string,
	sentAt time.Time,
) error {
	cmd := `INSERT INTO group_messages(chat_room_id, sender_id, message, created_at)
			VALUES ($1, $2, $3, $4)
		   `
	args := []any{
		roomdId,
		senderId,
		message,
		sentAt,
	}
	_, err := m.pool.Exec(ctx, cmd, args...)
	return err
}

func (m *Message) GetMessagesByRoomId(
	ctx context.Context,
	roomId string,
) (*[]dto.Message, error) {
	query := `
		SELECT 
		CASE 
			WHEN jcm.is_admin THEN o.profile_icon
			ELSE u.profile_pic_url
		END AS sender_profile_pic_url,
		CASE 
			WHEN jcm.is_admin THEN o.organization_name
			ELSE u.name
		END AS sender_name,
		u.username AS sender_username,
		u.id AS sender_id,
		gm.message,
		gm.created_at AS sent_time,
		gm.is_seen,
		gm.chat_room_id,
		jcm.is_admin
	FROM group_messages gm
	JOIN job_chat_members jcm ON gm.chat_room_id = jcm.chat_room_id AND gm.sender_id = jcm.user_id
	JOIN users u ON jcm.user_id = u.id
	LEFT JOIN organizations o ON jcm.user_id = o.user_id
	WHERE gm.chat_room_id = $1
	ORDER BY sent_time ASC
		`
	rows, err := m.pool.Query(ctx, query, roomId)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var messagesDto []dto.Message
	for rows.Next() {
		var messageDto dto.Message
		err := rows.Scan(
			&messageDto.SenderProfileIcon,
			&messageDto.SenderName,
			&messageDto.SenderUsername,
			&messageDto.SenderId,
			&messageDto.Message,
			&messageDto.SentTime,
			&messageDto.IsSeen,
			&messageDto.RoomId,
			&messageDto.IsAdmin,
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
			WITH latest_messages AS (
			SELECT chat_room_id,
				   message,
				   created_at,
				   is_seen,
				   ROW_NUMBER() OVER (PARTITION BY chat_room_id ORDER BY created_at DESC) as rn
			FROM group_messages
		)
		SELECT jcr.id AS chat_room_id, 
			   COALESCE(lm.message, '') AS message, 
			   COALESCE(lm.created_at, '1970-01-01 00:00:00') AS latest_message_time, 
			   jcm.is_admin, 
			   lm.is_seen,
			   o.profile_icon AS org_profile_icon, 
			   jcr.name AS room_name 
		FROM job_chat_rooms jcr
		JOIN org_jobs oj ON jcr.job_id = oj.id
		JOIN organizations o ON oj.org_id = o.id
		JOIN job_chat_members jcm ON jcr.id = jcm.chat_room_id
		LEFT JOIN latest_messages lm ON jcr.id = lm.chat_room_id AND lm.rn = 1
		WHERE jcm.user_id = $1;
			 `

	rows, err := m.pool.Query(
		ctx,
		query,
		userId,
	)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var roomsDto []dto.Room
	for rows.Next() {
		var roomDto dto.Room
		err := rows.Scan(
			&roomDto.RoomId,
			&roomDto.LatestText,
			&roomDto.SentTime,
			&roomDto.IsAdmin,
			&roomDto.IsSeen,
			&roomDto.RoomProfile,
			&roomDto.RoomName,
		)
		if err != nil {
			return &[]dto.Room{}, err
		}
		roomsDto = append(roomsDto, roomDto)
	}
	return &roomsDto, nil
}

func (m *Message) UpdateOnlineStatus(ctx context.Context, userId string, status bool) error {
	println("UPDATE IS CALLEd")
	cmd := `UPDATE users SET is_online = $1 WHERE id = $2`
	_, err := m.pool.Exec(ctx, cmd, status, userId)
	if err != nil {
		return err
	}
	return nil
}

func (m *Message) GetRoomIdsOfUserById(ctx context.Context, userId string) ([]string, error) {
	query := `SELECT job_chat_rooms.id from job_chat_rooms
	          JOIN job_chat_members ON job_chat_rooms.id = job_chat_members.chat_room_id
			  WHERE user_id = $1`
	rows, err := m.pool.Query(ctx, query, userId)
	if err != nil {
		return []string{}, err
	}
	defer rows.Close()
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
	if err != nil {
		return &[]dto.MemberInRoom{}, err
	}
	defer rows.Close()
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

func (c *Message) InsertMemeberToRoom(ctx context.Context, isOrg bool, userId, roomId string) error {
	cmd := `INSERT INTO job_chat_members(user_id, chat_room_id, is_admin) VALUES ($1, $2, $3)`
	_, err := c.pool.Exec(ctx, cmd, userId, roomId, isOrg)
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
