package ws

import (
	"context"
	"encoding/json"
	"log"
	"time"

	"github.com/gorilla/websocket"
)

type ClientList map[*Client]bool
type Client struct {
	connection *websocket.Conn
	manager    *Manager
	userId     string
	username   string
	egress     chan Event
	roomIds    []string
}

var (
	pongWait     = 10 * time.Second
	pingInterval = (pongWait * 9) / 10
)

func NewClient(
	conn *websocket.Conn,
	manager *Manager,
	roomIds []string,
	userId string,
	username string,
) *Client {
	return &Client{
		connection: conn,
		manager:    manager,
		egress:     make(chan Event),
		roomIds:    roomIds,
	}
}

func (c *Client) readMessages() {
	defer func() {
		c.manager.removeClient(c)
		c.manager.EventRepository.NotifyOnlineStatusChange(Event{}, c)
		c.manager.EventRepository.ChatRepository.UpdateOnlineStatus(context.Background(), c.userId, false)
	}()
	c.connection.SetReadLimit(512)
	if err := c.connection.SetReadDeadline(time.Now().Add(pongWait)); err != nil {
		log.Println(err)
		return
	}
	c.connection.SetPongHandler(func(appData string) error {
		log.Println("pong")
		return c.connection.SetReadDeadline(time.Now().Add(pongWait))
	})
	for {
		t, payload, err := c.connection.ReadMessage()
		_ = t
		if err != nil {
			if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway) {
				log.Printf("error reading message: %v", err)
			}
			break
		}
		var request Event
		if err := json.Unmarshal(payload, &request); err != nil {
			log.Printf("error marshalling message: %v", err)
			break

		}
		if err := c.manager.RouteEvent(request, c); err != nil {
			log.Println("error handling the message", err)
		}
	}

}

func (c *Client) writeMessages() {
	ticker := time.NewTicker(pingInterval)
	defer func() {
		ticker.Stop()
		c.manager.removeClient(c)
		c.manager.EventRepository.NotifyOnlineStatusChange(Event{}, c)
		c.manager.EventRepository.ChatRepository.UpdateOnlineStatus(context.Background(), c.userId, false)
	}()
	for {
		select {
		case message, ok := <-c.egress:
			if !ok {
				if err := c.connection.WriteMessage(websocket.CloseMessage, nil); err != nil {
					log.Println("connection is closed")
				}
				return
			}
			data, err := json.Marshal(message)
			if err != nil {
				log.Println("failed to marshall this thing")
				log.Println(err)
				return
			}
			if err := c.connection.WriteMessage(websocket.TextMessage, data); err != nil {
				log.Println(err)
			}
			log.Println("message is sent")
		case <-ticker.C:
			log.Println("ping")
			if err := c.connection.WriteMessage(websocket.PingMessage, []byte{}); err != nil {
				log.Println("failed to ping", err)
				return
			}
		}
	}
}
