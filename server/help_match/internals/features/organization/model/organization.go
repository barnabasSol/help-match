package model

import "time"

type Organization struct {
	Id          string    `json:"id"`
	UserId      string    `json:"user_id"`
	Name        string    `json:"org_name"`
	Description string    `json:"description"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
	Location    Location  `json:"location"`
	IsVerified  bool      `json:"is_verified"`
	Version     int       `json:"version"`
	Type        string    `json:"org_type"`
}

type Location struct {
	Latitude  float64
	Longitude float64
}
