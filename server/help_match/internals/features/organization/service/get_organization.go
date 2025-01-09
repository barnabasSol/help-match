package service

import (
	"context"

	job_dto "hm.barney-host.site/internals/features/job/dto"
	job_r "hm.barney-host.site/internals/features/job/repository"
	"hm.barney-host.site/internals/features/organization/dto"
	"hm.barney-host.site/internals/features/organization/repository"
	user_r "hm.barney-host.site/internals/features/users/repository"
)

type Organization struct {
	orgRepo  repository.OrgRepository
	jobRepo  job_r.JobRepository
	userRepo user_r.UserRepository
}

func NewOrgService(
	orgRepo repository.OrgRepository,
	jobRepo job_r.JobRepository,
	userRepo user_r.UserRepository,
) *Organization {
	return &Organization{orgRepo, jobRepo, userRepo}
}

func (os *Organization) GetOrganization(
	ctx context.Context,
	orgId string,
) (*dto.OrgResponseExtras, error) {
	var orgResult dto.OrgResponseExtras
	orgResult.OrgResult.Id = orgId
	org, err := os.orgRepo.GetOrganization(ctx, orgId)
	if err != nil {
		return nil, err
	}
	orgResult = dto.OrgResponseExtras{
		OrgResult: dto.OrgResponse{
			UserId:      org.UserId,
			Name:        org.Name,
			ProfileIcon: org.ProfileIcon,
			Description: org.Description,
			CreatedAt:   org.CreatedAt,
			IsVerified:  org.IsVerified,
			Version:     org.Version,
			Type:        org.Type,
			Location: dto.Location{
				Latitude:  org.Location.Latitude,
				Longitude: org.Location.Longitude,
			},
		},
	}
	jobs, err := os.jobRepo.GetJobsByOrgId(ctx, org.Id)

	if err != nil {
		return nil, err
	}
	for _, job := range jobs {
		orgResult.AvailableJobs = append(orgResult.AvailableJobs, job_dto.JobResponse{
			Id:          job.Id,
			Title:       job.Title,
			Description: job.Description,
			UpdatedAt:   job.UpdatedAt,
			CreatedAt:   job.CreatedAt,
			Version:     job.Version,
		})
	}
	user, err := os.userRepo.FindUserById(ctx, org.UserId)
	if err != nil {
		return nil, err
	}

	orgResult.Owner.Username = user.Username
	orgResult.Owner.Name = user.Name
	orgResult.Owner.Email = user.Email
	orgResult.Owner.ProfilePicUrl = user.ProfilePicUrl
	orgResult.Owner.CreatedAt = user.CreatedAt
	orgResult.Owner.Version = user.Version

	return &orgResult, nil
}
