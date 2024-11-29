package dto

import "hm.barney-host.site/internals/features/organization/dto"

type Signup struct {
	dto.OrgSignup
	Name          string      `json:"name"`
	Username      string      `json:"username"`
	ProfilePicUrl string      `json:"profile_pic_url"`
	Email         string      `json:"email"`
	Password      string      `json:"password"`
	Role          AllowedRole `json:"role"`
	Interests     []string    `json:"interests"`
}

type AllowedRole string

const (
	User         AllowedRole = "user"
	Organization AllowedRole = "organization"
)

func (ar AllowedRole) IsValid() bool {
	switch ar {
	case User:
		return true
	case Organization:
		return true
	default:
		return false
	}
}
