package repository

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"hm.barney-host.site/internals/features/users/model"
	"hm.barney-host.site/internals/features/utils"
)

type AuthRepository interface {
	InsertRefreshToken(
		ctx context.Context,
		tx pgx.Tx,
		token string,
		user *model.User,
	) error

	WithTransaction(
		ctx context.Context,
		fn func(pgx.Tx) error,
	) error
}

type Auth struct {
	pgPool *pgxpool.Pool
}

func NewAuthRepository(pgPool *pgxpool.Pool) *Auth {
	return &Auth{pgPool}
}

func (r *Auth) WithTransaction(ctx context.Context, fn func(pgx.Tx) error) error {
	return utils.TransactionScope(ctx, r.pgPool, fn)
}

func (ar *Auth) InsertRefreshToken(
	ctx context.Context,
	tx pgx.Tx,
	token string,
	user *model.User,
) error {
	cmd := `
	INSERT INTO refresh_tokens (user_id, token, expires_at) 
	VALUES($1, $2, $3)
	`
	args := []any{user.Id, token, time.Now().Add(time.Hour * 24 * 7)}
	if tx == nil {
		_, err := ar.pgPool.Exec(ctx, cmd, args...)
		if err != nil {
			return err
		}
	} else {
		_, err := tx.Exec(ctx, cmd, args...)
		if err != nil {
			return err
		}
	}
	return nil
}
