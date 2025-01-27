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
	"hm.barney-host.site/internals/features/utils"
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
	Clients         ClientList
	Handlers        map[string]EventHandler
	Otps            RetentionMap
	EventRepository EventRepository
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
	log.Println("new connection")
	conn, err := websocketUpgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println(err)
		http.Error(w, "Some bullshit happened when serving ws", http.StatusInternalServerError)
		return
	}

	claims := r.Context().Value(utils.ClaimsKey).(utils.Claims)

	roomIds, err := m.EventRepository.ChatRepository.GetRoomIdsOfUserById(r.Context(), claims.Subject)
	if err != nil {
		log.Println(err)
		http.Error(w, "Some bullshit happened when serving ws", http.StatusInternalServerError)
		return
	}

	newClient := NewClient(
		conn,
		m,
		roomIds,
		claims.Subject,
		claims.Username,
	)
	m.addClient(newClient)
	go newClient.readMessages()
	go newClient.writeMessages()
	go m.EventRepository.NotifyOnlineStatusChange(Event{}, newClient)
	go m.EventRepository.ChatRepository.UpdateOnlineStatus(r.Context(), claims.Subject, true)
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
