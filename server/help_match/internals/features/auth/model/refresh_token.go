package model

import "time"

type RefreshToken struct {
	Id        string    `json:"id"`
	UserID    string    `json:"user_id"`
	Token     string    `json:"token"`
	ExpiresAt time.Time `json:"expires_at"`
	CreatedAt time.Time `json:"created_at"`
}

// id UUID NOT NULL DEFAULT uuid_generate_v1mc(),
// user_id UUID REFERENCES users(id) ON DELETE CASCADE,
// token TEXT NOT NULL,
// expires_at TIMESTAMP NOT NULL,
// created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
