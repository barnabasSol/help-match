package model

import "time"

type JobChatMember struct {
	ChatRoomId string    `json:"chat_room_id"`
	UserId     string    `json:"user_id"`
	JoinedAt   time.Time `json:"joined_at"`
	LeftAt     time.Time `json:"left_at"`
}
