package model

import "time"

type Job struct {
	Id          string    `json:"id"`
	OrgId       string    `json:"org_id"`
	Title       string    `json:"job_title"`
	Description string    `json:"job_description"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
	Version     int       `json:"version"`
}
