package dto

import (
	org_dto "hm.barney-host.site/internals/features/organization/dto"
	user_dto "hm.barney-host.site/internals/features/users/dto"
)

type SignupResponse struct {
	OrgResponse *org_dto.OrgResponse `json:"org,omitempty"`
	User        user_dto.User        `json:"user"`
	Tokens      Tokens               `json:"tokens"`
	OTP         string               `json:"otp"`
}
