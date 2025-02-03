package model

import "time"

type User struct {
	Id            string    `json:"id"`
	Name          string    `json:"name"`
	Username      string    `json:"username"`
	Email         string    `json:"email"`
	ProfilePicUrl string    `json:"profile_pic_url"`
	IsOnline      *bool     `json:"is_online,omitempty"`
	Interests     []string  `json:"interests"`
	PasswordHash  []byte    `json:"password"`
	IsActivated   bool      `json:"is_activated"`
	Role          string    `json:"role"`
	CreatedAt     time.Time `json:"created_at"`
	Version       int       `json:"version"`
}
