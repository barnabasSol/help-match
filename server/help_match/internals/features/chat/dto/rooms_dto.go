package dto

import "time"

type Room struct {
	RoomProfile string   `json:"room_profile"`
	RoomId      string   `json:"room_id"`
	IsAdming    bool     `json:"is_admin"`
	RoomName    string   `json:"room_name"`
	LatestText  string   `json:"latest_text"`
	SentTime    time.Time `json:"sent_time"`
}
