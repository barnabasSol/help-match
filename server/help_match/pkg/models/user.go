package models

import "time"

type User struct {
	Id           string    `json:"id"`
	Username     string    `json:"username"`
	Name         string    `json:"name"`
	Email        string    `json:"email"`
	PasswordHash []byte    `json:"password"`
	IsActivated  string    `json:"is_activated"`
	CreatedAt    time.Time `json:"created_at"`
	Version      int       `json:"version"`
}
