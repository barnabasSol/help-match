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
	Insert(ctx context.Context, tx pgx.Tx, user *model.Job) error
}
type Job struct {
	pgPool *pgxpool.Pool
}

func (j *Job) WithTransaction(ctx context.Context, fn func(pgx.Tx) error) error {
	return utils.TransactionScope(ctx, j.pgPool, fn)
}

func (j *Job) Insert(ctx context.Context, tx pgx.Tx, user *model.Job) error {
	panic("not done yet")
}
