package dto

import "time"

type User struct {
	Name          string            `json:"name"`
	Username      string            `json:"username"`
	Email         string            `json:"email"`
	ProfilePicUrl string            `json:"profile_pic_url"`
	IsActivated   bool              `json:"is_activated"`
	Interests     *AllowedInterests `json:"interests,omitempty"`
	CreatedAt     time.Time         `json:"created_at"`
	Version       int               `json:"version"`
}

type AllowedInterests []string
