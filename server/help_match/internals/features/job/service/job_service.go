package service

import (
	"context"
	"errors"
	"fmt"

	c_r "hm.barney-host.site/internals/features/chat/repository"
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
	cr c_r.MessageRepository
}

func NewJobService(
	jr repository.JobRepository,
	nr n_r.NotificationRepository,
	or o_r.OrgRepository,
	cr c_r.MessageRepository,
) *Job {
	return &Job{jr, nr, or, cr}

}

func (j *Job) AddNewOrgJob(
	ctx context.Context,
	orgId string,
	incommingJob dto.JobAddDto,
) (*dto.JobResponse, error) {
	newJob := model.Job{
		OrgId:       orgId,
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
		UpdatedAt:   nil,
		Version:     newJob.Version,
	}, nil
}

func (j *Job) DeleteOrgJob(ctx context.Context, jobId, orgId string) error {
	job, err := j.jr.GetJobByOrgId(ctx, orgId)
	if err != nil {
		return nil
	}
	if job.Id != jobId {
		return errors.New("you're not allowed to delete this job")
	}
	err = j.jr.Delete(ctx, nil, jobId)
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

func (j *Job) UpdateJobStatus(
	ctx context.Context,
	updateDto dto.JobUpdateDto,
	orgHandlerId string,
) error {
	err := updateDto.Validate()
	if err != nil {
		return err
	}
	message := notificationMessageFromStatus(updateDto.Status)
	if message == "" {
		return nil
	}
	_, err = j.jr.GetJobById(ctx, updateDto.JobID)
	if err != nil {
		return err
	}
	err = j.jr.UpdateJobStatus(ctx, nil, updateDto.JobID, updateDto.UserId, updateDto.Status)
	if err != nil {
		return err
	}
	room_exists, err := j.cr.JobChatRoomExists(ctx, updateDto.JobID)

	if err != nil {
		return err
	}
	roomId := ""
	if !room_exists {
		org, err := j.or.GetOrganizationByJobId(ctx, updateDto.JobID)
		if err != nil {
			return err
		}
		job, err := j.jr.GetJobByOrgId(ctx, org.Id)
		if err != nil {
			return err
		}
		roomName := fmt.Sprintf("%s  (%s)", job.Title, org.Name)
		roomId, err = j.cr.InsertJobRoom(ctx, updateDto.JobID, roomName)
		if err != nil {
			return err
		}
		err = j.cr.InsertMemeberToRoom(ctx, true, orgHandlerId, roomId)
		if err != nil {
			return err
		}
	} else {
		roomId, err = j.cr.GetRoomIdByJobId(ctx, updateDto.JobID)
		if err != nil {
			return err
		}
	}
	if updateDto.Status == Accepted {
		err = j.cr.InsertMemeberToRoom(ctx, false, updateDto.UserId, roomId)
		if err != nil {
			return err
		}
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
