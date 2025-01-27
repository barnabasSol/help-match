package model

import "time"

type Notification struct {
	Id        string    `json:"string"`
	FromId    string    `json:"from_id"`
	ToId      string    `json:"to_id"`
	Message   string    `json:"message"`
	CreatedAt time.Time `json:"created_at"`
}
