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

	var newMessageEvent NewMessageEvent

	newMessageEvent.Message = sendEvent.Message
	newMessageEvent.ToRoomId = sendEvent.ToRoomId
	newMessageEvent.FromId = sendEvent.FromId
	newMessageEvent.SentTime = sendEvent.SentTime

	marshalledNewEvent, err := json.Marshal(newMessageEvent)
	if err != nil {
		return fmt.Errorf("failed to marshal broadcast message: %v", err)
	}
	c.manager.RLock()
	for client := range c.manager.Clients {
		if _, exists := client.roomIds[sendEvent.ToRoomId]; exists {
			client.egress <- Event{
				Type:    TypeNewMessage,
				Payload: marshalledNewEvent,
			}
		}
	}
	c.manager.RUnlock()
	err = e.ChatRepository.InsertMessage(
		context.Background(),
		sendEvent.FromId,
		sendEvent.ToRoomId,
		sendEvent.Message,
		sendEvent.SentTime,
	)
	if err != nil {
		log.Println(err)
		return errors.New("failed to store message")
	}
	return nil
}

func (e *EventRepository) NotifyOnlineStatusChange(ev Event, c *Client) error {
	c.manager.RLock()
	for client := range c.manager.Clients {
		client.egress <- ev
	}
	c.manager.RUnlock()

	return nil
}
func (e *EventRepository) PushNewNotification(ev Event, c *Client) error {
	return nil
}
