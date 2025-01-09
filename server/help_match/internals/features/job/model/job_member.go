package model

type JobChatMember struct {
	ChatRoomId string `json:"chat_room_id"`
	UserId     string `json:"user_id"`
	JoinedAt   string `json:"joined_at"`
	LeftAt     string `json:"left_at"`
}
