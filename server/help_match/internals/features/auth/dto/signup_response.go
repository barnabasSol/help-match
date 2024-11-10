package dto

import (
	"hm.barney-host.site/internals/features/users/dto"
)

type SignupResponse struct {
	User   dto.User `json:"user"`
	Tokens Tokens   `json:"tokens"`
}
