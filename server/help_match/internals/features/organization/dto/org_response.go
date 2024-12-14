package dto

import (
	"time"

	job_dto "hm.barney-host.site/internals/features/job/dto"
	user_dto "hm.barney-host.site/internals/features/users/dto"
)

type OrgResponse struct {
	Id          string    `json:"org_id"`
	Name        string    `json:"org_name"`
	UserId      string    `json:"user_id"`
	ProfileIcon string    `json:"profile_icon"`
	Description string    `json:"description"`
	Location    Location  `json:"location"`
	IsVerified  bool      `json:"is_verified"`
	CreatedAt   time.Time `json:"created_at"`
	Type        string    `json:"type"`
	Version     int       `json:"version"`
}

type OrgResponseExtras struct {
	OrgResponse
	Owner         user_dto.User         `json:"owner"`
	AvailableJobs []job_dto.JobResponse `json:"jobs"`
}
