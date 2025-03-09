package dto

import "time"

type JobResponse struct {
	Id              string     `json:"id"`
	Title           string     `json:"title"`
	Description     string     `json:"description"`
	ApplicantStatus string     `json:"applicant_status"`
	UpdatedAt       *time.Time `json:"updated_at,omitempty"`
	CreatedAt       time.Time  `json:"created_at"`
	Version         int        `json:"version"`
}
