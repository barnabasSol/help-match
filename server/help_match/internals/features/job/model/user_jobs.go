package model

import "time"

type UserJob struct {
	Id        string    `json:"id"`
	UserId    string    `json:"user_id"`
	JobId     string    `json:"job_id"`
	JobStatus string    `json:"job_status"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
	Version   int       `json:"version"`
}
