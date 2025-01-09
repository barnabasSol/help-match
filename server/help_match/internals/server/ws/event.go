package ws

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log"

	"hm.barney-host.site/internals/features/chat/repository"
)

type EventRepository struct {
	ChatRepository repository.MessageRepository
}

type Event struct {
	Type    string          `json:"type"`
	Payload json.RawMessage `json:"payload"`
}

type EventHandler func(event Event, c *Client) error

func (e *EventRepository) SendMessageHandler(event Event, c *Client) error {
	var sendEvent SendMessageEvent
	if err := json.Unmarshal(event.Payload, &sendEvent); err != nil {
		return fmt.Errorf("bad/invalid payload in request: %v", err)
	}

	on, err := e.ChatRepository.InsertMessage(
		context.Background(),
		sendEvent.FromId,
		sendEvent.ToRoomId,
		sendEvent.Message,
	)

	if err != nil {
		log.Println(err)
		return errors.New("failed to store message")
	}

	var newMessageEvent NewMessageEvent

	newMessageEvent.Message = sendEvent.Message
	newMessageEvent.ToRoomId = sendEvent.ToRoomId
	newMessageEvent.FromId = sendEvent.FromId
	newMessageEvent.SentAt = on

	marshalledNewEvent, err := json.Marshal(newMessageEvent)
	if err != nil {
		return fmt.Errorf("failed to marshal broadcast message: %v", err)
	}

	for client := range c.manager.Clients {
		for _, roomId := range client.roomIds {
			if roomId == sendEvent.ToRoomId {
				client.egress <- Event{
					Type:    TypeNewMessage,
					Payload: marshalledNewEvent,
				}
			}
		}

	}
	return nil
}
func (e *EventRepository) NotifyOnlineStatusChange(ev Event, c *Client) error {
	var statusEventPayload []byte
	var err error

	c.manager.RLock()
	isOnline := false
	if _, found := c.manager.Clients[c]; found {
		isOnline = true
	}
	clientsToNotify := make([]*Client, 0)
	for client := range c.manager.Clients {
		clientsToNotify = append(clientsToNotify, client)
	}
	c.manager.RUnlock()

	statusEventPayload, err = json.Marshal(OnlineStatus{
		Username: c.username,
		Status:   isOnline,
	})
	if err != nil {
		return fmt.Errorf("failed to marshal online status event: %v", err)
	}

	for _, client := range clientsToNotify {
		select {
		case client.egress <- Event{
			Type:    TypeOnlineStatus,
			Payload: statusEventPayload,
		}:
			log.Println("is being notified")
		default:
		}
	}
	return nil
}
