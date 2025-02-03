package dto

import (
	"time"
)

type OrgListResponse struct {
	Id          string    `json:"org_id"`
	Name        string    `json:"org_name"`
	UserId      string    `json:"user_id"`
	ProfileIcon string    `json:"profile_icon"`
	Description string    `json:"description"`
	Proximity   float64   `json:"proximity"`
	Location    Location  `json:"location"`
	IsVerified  bool      `json:"is_verified"`
	CreatedAt   time.Time `json:"created_at"`
	Type        string    `json:"type"`
	Version     int       `json:"version"`
}
