package dto

import "time"

type JobApplicantDto struct {
	VolunteerId string    `json:"volunteer_id"`
	Username    string    `json:"username"`
	Name        string    `json:"name"`
	ProfileIcon string    `json:"profile_icon"`
	JobId       string    `json:"job_id"`
	Status      string    `json:"status"`
	CreatedAt   time.Time `json:"created_at"`
}
