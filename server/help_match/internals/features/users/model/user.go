package model

import "time"

type User struct {
	Id             string    `json:"id"`
	Name           string    `json:"name"`
	Username       string    `json:"username"`
	Email          string    `json:"email"`
	ProfilePicUrl  string    `json:"profile_pic_url"`
	PasswordHash   []byte    `json:"password"`
	IsActivated    bool      `json:"is_activated"`
	IsOrganization bool      `json:"is_organization"`
	CreatedAt      time.Time `json:"created_at"`
	Version        int       `json:"version"`
}
