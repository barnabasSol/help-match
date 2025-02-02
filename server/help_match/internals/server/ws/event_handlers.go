package ws

import (
	"encoding/json"
	"log"
)

func (m *Manager) setupEventHandlers() {
	m.Handlers[TypeSendMessage] = m.EventRepository.SendMessageHandler
	m.Handlers[TypeOnlineStatus] = m.EventRepository.NotifyOnlineStatusChange
	// m.handlers[EventChangeRoom] = ChatRoomHandler
}

func notifyOnlineStatusChange(c *Client, status bool) {
	statusEventPayload, err := json.Marshal(OnlineStatus{
		UserId:   c.userId,
		Username: c.username,
		Status:   status,
	})
	if err != nil {
		log.Println("failed to marshall")
	}
	c.manager.EventRepository.NotifyOnlineStatusChange(Event{
		Type:    TypeOnlineStatus,
		Payload: statusEventPayload,
	}, c)
}
