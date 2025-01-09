package model

import "time"

type JobRoom struct {
	Id        string    `json:"id"`
	JobId     string    `json:"job_id"`
	Name      string    `json:"name"`
	CreatedAt time.Time `json:"created_at"`
}
