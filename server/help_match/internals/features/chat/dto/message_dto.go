package dto

type Message struct {
	SenderProfileIcon string `json:"sender_profile"`
	SenderId          string `json:"sender_id"`
	Message           string `json:"message"`
	RoomId            string `json:"room_id"`
	SentTime          string `json:"sent_time"`
	IsSeen            bool   `json:"is_seen"`
}
