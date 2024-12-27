package ws

import (
	"context"
	"encoding/json"
	"errors"
	"log"
	"net/http"
	"sync"
	"time"

	"github.com/gorilla/websocket"
	"github.com/julienschmidt/httprouter"
)

var (
	websocketUpgrader = websocket.Upgrader{
		CheckOrigin: func(r *http.Request) bool {
			return true
		},
		ReadBufferSize:  1024,
		WriteBufferSize: 1024,
	}
)

type Manager struct {
	sync.RWMutex
	Clients  ClientList
	Handlers map[string]EventHandler
	Otps     RetentionMap
}

func NewManager(ctx context.Context) *Manager {
	m := &Manager{
		Clients:  make(ClientList),
		Handlers: make(map[string]EventHandler),
		Otps:     NewRetentionMap(ctx, 5*time.Second),
	}
	m.setupEventHandlers()
	return m
}

func (m *Manager) RouteEvent(event Event, c *Client) error {
	if handler, ok := m.Handlers[event.Type]; ok {
		if err := handler(event, c); err != nil {
			return err
		}
		return nil
	} else {
		return errors.New("event not supported")
	}
}

func (m *Manager) ServeWS(
	w http.ResponseWriter,
	r *http.Request,
	_ httprouter.Params,
) {
	otp := r.URL.Query().Get("otp")
	if otp == "" {
		w.WriteHeader(http.StatusUnauthorized)
		return
	}
	if !m.Otps.VerifyOTP(otp) {
		w.WriteHeader(http.StatusUnauthorized)
		return
	}
	conn, err := websocketUpgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println(err)
		return
	}
	newClient := NewClient(conn, m)
	m.addClient(newClient)

	go newClient.readMessages()
	go newClient.writeMessages()

}

func (m *Manager) RenewOTP(
	w http.ResponseWriter,
	r *http.Request,
	_ httprouter.Params,
) {
	type response struct {
		OTP string `json:"otp"`
	}
	otp := m.Otps.NewOTP()
	resp := response{
		OTP: otp.Key,
	}
	data, err := json.Marshal(resp)
	if err != nil {
		log.Println(err)
		return
	}
	// Return a response to the Authenticated user with the OTP
	w.WriteHeader(http.StatusOK)
	w.Write(data)
}

func (m *Manager) addClient(client *Client) {
	m.Lock()
	defer m.Unlock()
	m.Clients[client] = true
}

func (m *Manager) removeClient(client *Client) {
	m.Lock()
	defer m.Unlock()
	if _, ok := m.Clients[client]; ok {
		client.connection.Close()
		delete(m.Clients, client)
	}
}

func (m *Manager) setupEventHandlers() {
	// m.handlers[EventSendMessage] = SendMessageHandler
	// m.handlers[EventChangeRoom] = ChatRoomHandler
}
