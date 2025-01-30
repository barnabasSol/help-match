package ws

import "time"

const TypeSendMessage = "send_message"

type SendMessageEvent struct {
	Message  string `json:"message"`
	FromId   string `json:"from_id"`
	ToRoomId string `json:"to_room_id"`
}

const TypeNewMessage = "new_message"

type NewMessageEvent struct {
	SendMessageEvent
	SentAt time.Time `json:"sent_at"`
}

const TypeOnlineStatus = "online_status_change"

type OnlineStatus struct {
	UserId   string `json:"user_id"`
	Username string `json:"username"`
	Status   bool   `json:"online_status"`
}

const TypePushNotification = "push_notification"

type PushNotification struct {
	Username string `json:"username"`
	Status   bool   `json:"online_status"`
}
