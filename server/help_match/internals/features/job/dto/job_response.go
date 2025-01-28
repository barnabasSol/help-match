package dto

import "time"

type JobResponse struct {
	Id          string     `json:"id"`
	Title       string     `json:"title"`
	Description string     `json:"description"`
	UpdatedAt   *time.Time `json:"updated_at,omitempty"`
	CreatedAt   time.Time  `json:"created_at"`
	Version     int        `json:"version"`
}
