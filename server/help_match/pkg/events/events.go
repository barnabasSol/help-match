package events

import (
	"encoding/json"
	"time"
)

type Event struct {
	Type    string          `json:"type"`
	Payload json.RawMessage `json:"payload"`
}

const (
	SendMessageType = "send_message"
	NewMessageType  = "new_message"
	ChangeRoomType  = "change_room"
)

type SendMessageEvent struct {
	Message string `json:"message"`
	From    string `json:"from"`
	To      string `json:"to"`
}

type NewMessageEvent struct {
	SendMessageEvent
	Sent time.Time `json:"sent"`
}

type ChangeRoomEvent struct {
	Name string `json:"name"`
}
