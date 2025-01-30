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
	c.manager.RLock()
	for client := range c.manager.Clients {
		for _, roomId := range client.roomIds {
			if roomId == sendEvent.ToRoomId {
				client.egress <- Event{
					Type:    TypeNewMessage,
					Payload: marshalledNewEvent,
				}
				break
			}
		}

	}
	c.manager.RUnlock()
	return nil
}

func (e *EventRepository) NotifyOnlineStatusChange(ev Event, c *Client) error {
	isOnline := false
	c.manager.RLock()
	for v := range c.manager.Clients {
		if v.userId == c.userId {
			isOnline = true
			break
		}
	}
	c.manager.RUnlock()

	statusEventPayload, err := json.Marshal(OnlineStatus{
		UserId:   c.userId,
		Username: c.username,
		Status:   isOnline,
	})

	if err != nil {
		return fmt.Errorf("failed to marshal online status event: %v", err)
	}

	c.manager.RLock()
	for client := range c.manager.Clients {
		client.egress <- Event{
			Type:    TypeOnlineStatus,
			Payload: statusEventPayload,
		}
	}
	c.manager.RUnlock()

	return nil
}
func (e *EventRepository) PushNewNotification(ev Event, c *Client) error {
	return nil
}
