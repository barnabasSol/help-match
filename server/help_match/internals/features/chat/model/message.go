package model

import "time"

type GroupMessage struct {
	Id         string    `json:"id"`
	ChatRoomId string    `json:"chat_id"`
	SenderId   string    `json:"sender_id"`
	Message    string    `json:"message"`
	CreatedAt  time.Time `json:"created_at"`
}
