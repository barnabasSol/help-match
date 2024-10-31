package models

type User struct {
	Id           string `json:"id"`
	Username     string `json:"username"`
	Name         string `json:"name"`
	Email        string `json:"email"`
	PasswordHash string `json:"password"`
	IsActivated  string `json:"is_activated"`
	Version      string `json:"version"`
}
