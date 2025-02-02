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
	userId     string
	username   string
	roomIds    []string
	connection *websocket.Conn
	manager    *Manager
	egress     chan Event
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
		username:   username,
		userId:     userId,
	}
}

func (c *Client) readMessages() {
	defer func() {
		log.Println(c.username, " disconnected")
		c.manager.removeClient(c)
		notifyOnlineStatusChange(c, false)
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
			if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway, websocket.CloseAbnormalClosure) {
				log.Printf("error reading message: %v", err)
			}
			break
		}
		var request Event
		if err := json.Unmarshal(payload, &request); err != nil {
			log.Printf("error marshalling message: %v", err)
			break

		}
		log.Println(request)
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
				log.Println("failed to ping, client is gone", err)
				return
			}
		}
	}
}
