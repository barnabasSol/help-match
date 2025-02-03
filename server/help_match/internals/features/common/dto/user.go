package common

import "time"

type User struct {
	Id            string            `json:"id"`
	Name          string            `json:"name"`
	Username      string            `json:"username"`
	Email         string            `json:"email"`
	ProfilePicUrl string            `json:"profile_pic_url"`
	Role          string            `json:"role"`
	IsActivated   bool              `json:"is_activated"`
	IsOnline      bool              `json:"is_online"`
	Interests     *AllowedInterests `json:"interests,omitempty"`
	CreatedAt     time.Time         `json:"created_at"`
	Version       int               `json:"version"`
	OrgInfo       *OrgInfo          `json:"org_info,omitempty"`
}

type OrgInfo struct {
	Id          string    `json:"org_id"`
	Name        string    `json:"org_name"`
	ProfileIcon string    `json:"profile_icon"`
	Description string    `json:"description"`
	Location    Location  `json:"location"`
	IsVerified  bool      `json:"is_verified"`
	CreatedAt   time.Time `json:"created_at"`
	Type        string    `json:"type"`
	Version     int       `json:"version"`
}

type Location struct {
	Latitude  float64 `json:"latitude"`
	Longitude float64 `json:"longitude"`
}
type AllowedInterests []string
