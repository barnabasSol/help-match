package ws

import "encoding/json"

type Event struct {
	// Type is the message type sent
	Type string `json:"type"`
	// Payload is the data Based on the Type
	Payload json.RawMessage `json:"payload"`
}

type EventHandler func(event Event, c *Client) error

type NewMessageEvent struct{}
type NewNotificationEvent struct{}
type SendMessageEvent struct{}
