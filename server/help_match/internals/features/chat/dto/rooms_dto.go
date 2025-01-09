package dto

type Room struct {
	RoomProfile string `json:"room_profile"`
	RoomId      string `json:"room_id"`
	JobId       string `json:"job_id"`
	RoomName    string `json:"room_name"`
	LatestText  string `json:"latest_text"`
	SentTime    string `json:"sent_time"`
}
