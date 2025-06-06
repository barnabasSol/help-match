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
	wg *sync.WaitGroup
	sync.RWMutex
	Clients         ClientList
	Handlers        map[string]EventHandler
	Otps            *RetentionMap
	EventRepository EventRepository
}

func NewManager(ctx context.Context, wg *sync.WaitGroup) *Manager {
	m := &Manager{
		wg:       wg,
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
	}
	return errors.New("event not supported")
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
	roomMap := make(map[string]struct{}, len(roomIds))
	for _, id := range roomIds {
		roomMap[id] = struct{}{}
	}
	newClient := NewClient(
		conn,
		m,
		roomMap,
		claims.Subject,
		claims.Username,
	)
	m.addClient(newClient)
	go newClient.readMessages()
	go newClient.writeMessages()
	go notifyOnlineStatusChange(newClient, true)
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
