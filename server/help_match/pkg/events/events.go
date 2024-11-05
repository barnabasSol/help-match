package events

import (
	"encoding/json"
	"time"
)

type Event struct {
	// Type is the message type sent
	Type string `json:"type"`
	// Payload is the data Based on the Type
	Payload json.RawMessage `json:"payload"`
}

const (
	// EventSendMessage is the event name for new chat messages sent
	SendMessageType = "send_message"
	// EventNewMessage is a response to send_message
	NewMessageType = "new_message"
	// EventChangeRoom is event when switching rooms
	ChangeRoomType = "change_room"
)

type SendMessageEvent struct {
	Message string `json:"message"`
	From    string `json:"from"`
}

// NewMessageEvent is returned when responding to send_message
type NewMessageEvent struct {
	SendMessageEvent
	Sent time.Time `json:"sent"`
}

type ChangeRoomEvent struct {
	Name string `json:"name"`
}
