package dto

import "time"

type Message struct {
	SenderProfileIcon string    `json:"sender_profile"`
	SenderId          string    `json:"sender_id"`
	SenderName        string    `json:"sender_name"`
	SenderUsername    string    `json:"sender_username"`
	IsAdmin           bool      `json:"is_admin"`
	RoomId            string    `json:"room_id"`
	Message           string    `json:"message"`
	SentTime          time.Time `json:"sent_time"`
	IsSeen            bool      `json:"is_seen"`
}
