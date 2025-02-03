package dto

import (
	user_dto "hm.barney-host.site/internals/features/common/dto"
	org_dto "hm.barney-host.site/internals/features/organization/dto"
)

type SignupResponse struct {
	OrgResponse *org_dto.OrgResponse `json:"org,omitempty"`
	User        user_dto.User        `json:"user"`
	Tokens      Tokens               `json:"tokens"`
	OTP         string               `json:"otp"`
}
