package dto

import "time"

type MemberInRoom struct {
	Name            string    `json:"name"`
	UserId          string    `json:"user_id"`
	Username        string    `json:"username"`
	JoinedAt        time.Time `json:"joined_at"`
	Role            string    `json:"role"`
	OnlineStatus    bool      `json:"online_status"`
	UserProfileIcon string    `json:"profile_icon"`
}
