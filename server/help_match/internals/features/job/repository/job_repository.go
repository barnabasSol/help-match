package repository

import (
	"context"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"hm.barney-host.site/internals/features/job/model"
	"hm.barney-host.site/internals/features/utils"
)

type JobRepository interface {
	WithTransaction(ctx context.Context, fn func(pgx.Tx) error) error
	GetJobsByOrgId(ctx context.Context, orgId string) ([]*model.Job, error)
	Insert(ctx context.Context, tx pgx.Tx, job *model.Job) error
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
	panic("not done yet")
}

func (j *Job) GetJobsByOrgId(ctx context.Context, orgId string) ([]*model.Job, error) {
	query := `SELECT id, org_id, job_title, description,
	    	  created_at, updated_at, version FROM org_jobs WHERE org_id = $1`

	rows, err := j.pgPool.Query(ctx, query, orgId)
	defer rows.Close()
	var jobs []*model.Job
	if err != nil {
		return nil, err
	}
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
		)
		if err != nil {
			return nil, err
		}
		jobs = append(jobs, &job)
	}
	return jobs, nil
}
