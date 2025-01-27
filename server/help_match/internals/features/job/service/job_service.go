package service

import (
	"context"

	"hm.barney-host.site/internals/features/job/dto"
	"hm.barney-host.site/internals/features/job/model"
	"hm.barney-host.site/internals/features/job/repository"
	n_dto "hm.barney-host.site/internals/features/notifications/dto"
	n_r "hm.barney-host.site/internals/features/notifications/repository"
	o_r "hm.barney-host.site/internals/features/organization/repository"
)

type Job struct {
	jr repository.JobRepository
	nr n_r.NotificationRepository
	or o_r.OrgRepository
}

func NewJobService(jr repository.JobRepository, nr n_r.NotificationRepository, or o_r.OrgRepository) *Job {
	return &Job{jr, nr, or}

}

func (j *Job) AddNewOrgJob(
	ctx context.Context,
	incommingJob dto.JobAddDto,
) (*dto.JobResponse, error) {
	newJob := model.Job{
		OrgId:       incommingJob.OrgId,
		Title:       incommingJob.Title,
		Description: incommingJob.Description,
	}
	err := j.jr.Insert(ctx, nil, &newJob)
	if err != nil {
		return nil, err
	}
	return &dto.JobResponse{
		Id:          newJob.Id,
		Title:       newJob.Title,
		Description: newJob.Description,
		CreatedAt:   newJob.CreatedAt,
		UpdatedAt:   newJob.UpdatedAt,
		Version:     newJob.Version,
	}, nil
}

func (j *Job) DeleteOrgJob(ctx context.Context, jobId string) error {
	err := j.jr.Delete(ctx, nil, jobId)
	return err
}

func (j *Job) ApplyJob(
	ctx context.Context,
	volunteerId, jobId string,
) error {
	err := j.jr.InsertApplicant(ctx, nil, volunteerId, jobId)
	if err != nil {
		return err
	}
	org, err := j.or.GetOrganizationByJobId(ctx, jobId)
	if err != nil {
		return err
	}

	err = j.nr.AddNotification(ctx, n_dto.AddNotificationDto{
		FromId:  volunteerId,
		ToId:    org.UserId,
		Message: "New applicant for job",
	})
	return err
}

func (j *Job) UpdateJobStatus(ctx context.Context, updateDto dto.JobUpdateDto, orgHandlerId string) error {
	err := updateDto.Validate()
	if err != nil {
		return err
	}
	message := notificationMessageFromStatus(updateDto.Status)
	if message == "" {
		return nil
	}
	err = j.jr.UpdateJobStatus(ctx, nil, updateDto.JobID, updateDto.UserId, updateDto.Status)
	if err != nil {
		return err
	}
	j.nr.AddNotification(ctx, n_dto.AddNotificationDto{
		FromId:  orgHandlerId,
		ToId:    updateDto.UserId,
		Message: message,
	})
	return nil
}

func (j *Job) GetApplicants(ctx context.Context, orgId string) (*[]dto.JobApplicantDto, error) {
	var applicants []dto.JobApplicantDto
	err := j.jr.GetApplicantsByOrgId(ctx, &applicants, orgId)
	if err != nil {
		return nil, err
	}
	return &applicants, nil
}
