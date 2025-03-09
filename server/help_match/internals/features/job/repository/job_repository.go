package repository

import (
	"context"
	"fmt"
	"log"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"hm.barney-host.site/internals/features/job/dto"
	"hm.barney-host.site/internals/features/job/model"
	"hm.barney-host.site/internals/features/utils"
)

type JobRepository interface {
	WithTransaction(ctx context.Context, fn func(pgx.Tx) error) error
	GetJobsByOrgIdWithUserStatus(ctx context.Context, orgId, userId string) ([]*model.Job, error)
	GetJobByOrgId(ctx context.Context, orgId string) (model.Job, error)
	GetJobById(ctx context.Context, id string) (model.Job, error)
	GetApplicantsByOrgId(ctx context.Context, applicants *[]dto.JobApplicantDto, orgId string) error
	Insert(ctx context.Context, tx pgx.Tx, job *model.Job) error
	InsertApplicant(ctx context.Context, tx pgx.Tx, volunteerId, jobId string) error
	Delete(ctx context.Context, tx pgx.Tx, jobId, orgId string) error
	UpdateJobStatus(ctx context.Context, tx pgx.Tx, jobId, userId, status string) error
}

type Job struct {
	pgPool *pgxpool.Pool
}

func NewJobRepository(pgPool *pgxpool.Pool) *Job {
	return &Job{pgPool}
}
func (j *Job) WithTransaction(ctx context.Context, fn func(pgx.Tx) error) error {
	return utils.TransactionScope(ctx, j.pgPool, fn)
}

func (j *Job) Insert(ctx context.Context, tx pgx.Tx, job *model.Job) error {
	cmd := `INSERT INTO org_jobs (org_id, job_title, description)
			VALUES ($1, $2, $3) RETURNING id, created_at`
	err := j.pgPool.QueryRow(ctx, cmd, job.OrgId, job.Title, job.Description).Scan(
		&job.Id,
		&job.CreatedAt,
	)
	if err != nil {
		return err
	}
	return nil
}

func (j *Job) GetJobsByOrgIdWithUserStatus(ctx context.Context, orgId, userId string) ([]*model.Job, error) {
	query := `SELECT org_jobs.id, org_id, job_title, description, org_jobs.created_at,
	 		  org_jobs.updated_at, org_jobs.version,
			  CASE 
			  	WHEN user_jobs.user_id IS NULL THEN
					NULL	
				ELSE user_jobs.job_status
			  END AS applicant_status
			  FROM org_jobs LEFT JOIN user_jobs ON
			  user_jobs.job_id = org_jobs.id
			  WHERE org_id = $1 AND (user_jobs.user_id = $2 AND user_jobs.job_status != 'accepted')`

	rows, err := j.pgPool.Query(ctx, query, orgId, userId)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var jobs []*model.Job
	for rows.Next() {
		var job model.Job
		err := rows.Scan(
			&job.Id,
			&job.OrgId,
			&job.Title,
			&job.Description,
			&job.CreatedAt,
			&job.UpdatedAt,
			&job.Version,
			&job.ApplicantStatus,
		)
		if err != nil {
			return nil, err
		}
		jobs = append(jobs, &job)
	}
	return jobs, nil
}

func (j *Job) Delete(ctx context.Context, tx pgx.Tx, jobId, orgId string) error {
	cmd := `DELETE from org_jobs WHERE id=$1 AND org_id=$2`
	result, err := j.pgPool.Exec(ctx, cmd, jobId, orgId)
	if err != nil {
		return err
	}
	if result.RowsAffected() == 0 {
		return fmt.Errorf("job  does not exist")
	}
	return nil
}

func (j *Job) UpdateJobStatus(ctx context.Context, tx pgx.Tx, jobId, userId, status string) error {
	cmd := `UPDATE user_jobs SET job_status=$1 WHERE user_id=$2 AND job_id=$3`
	_, err := j.pgPool.Exec(ctx, cmd, status, userId, jobId)
	if err != nil {
		log.Printf("Error executing SQL: %v", err)
		return err
	}
	return nil
}

func (j *Job) InsertApplicant(ctx context.Context, tx pgx.Tx, volunteerId, jobId string) error {
	cmd := `INSERT INTO user_jobs (user_id, job_id) VALUES ($1, $2)`
	_, err := j.pgPool.Exec(ctx, cmd, volunteerId, jobId)
	return err
}

func (j *Job) GetApplicantsByOrgId(
	ctx context.Context,
	applicants *[]dto.JobApplicantDto,
	orgId string,
) error {
	query := `SELECT oj.id, uj.user_id, job_status, uj.created_at,
			  u.name, u.username, u.profile_pic_url
	 		  FROM user_jobs uj
			  JOIN org_jobs oj ON oj.id = uj.job_id
			  JOIN organizations o ON o.id = oj.org_id
			  JOIN users u ON u.id = uj.user_id
			  WHERE o.id = $1
			  `
	rows, err := j.pgPool.Query(ctx, query, orgId)
	defer rows.Close()
	if err != nil {
		return err
	}
	for rows.Next() {
		var applicant dto.JobApplicantDto
		err := rows.Scan(
			&applicant.JobId,
			&applicant.VolunteerId,
			&applicant.Status,
			&applicant.CreatedAt,
			&applicant.Name,
			&applicant.Username,
			&applicant.ProfileIcon,
		)
		if err != nil {
			return err
		}
		*applicants = append(*applicants, applicant)
	}
	return nil
}

func (j *Job) GetJobByOrgId(ctx context.Context, orgId string) (model.Job, error) {
	query := `SELECT id, org_id, job_title, description,
	    	  created_at, updated_at, version FROM org_jobs WHERE org_id = $1 `

	row := j.pgPool.QueryRow(ctx, query, orgId)
	var job model.Job
	err := row.Scan(
		&job.Id,
		&job.OrgId,
		&job.Title,
		&job.Description,
		&job.CreatedAt,
		&job.UpdatedAt,
		&job.Version,
	)
	if err != nil {
		return model.Job{}, err
	}
	return job, nil
}

func (j *Job) GetJobById(ctx context.Context, id string) (model.Job, error) {
	query := `SELECT id, org_id, job_title, description,
	    	  created_at, updated_at, version FROM org_jobs WHERE id = $1`

	row := j.pgPool.QueryRow(ctx, query, id)
	var job model.Job
	err := row.Scan(
		&job.Id,
		&job.OrgId,
		&job.Title,
		&job.Description,
		&job.CreatedAt,
		&job.UpdatedAt,
		&job.Version,
	)
	if err != nil {
		return model.Job{}, err
	}
	return job, nil
}
