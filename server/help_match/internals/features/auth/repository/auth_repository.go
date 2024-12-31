package repository

import (
	"context"
	"errors"
	"log"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	auth_model "hm.barney-host.site/internals/features/auth/model"
	user_model "hm.barney-host.site/internals/features/users/model"
	"hm.barney-host.site/internals/features/utils"
)

type AuthRepository interface {
	UpdateRefreshToken(ctx context.Context, userId string, newToken string) error
	GetRefreshToken(ctx context.Context, refreshToken string) (*auth_model.RefreshToken, error)
	InsertRefreshToken(
		ctx context.Context,
		tx pgx.Tx,
		token string,
		user *user_model.User,
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

var ExpiresAt = time.Now().Add(time.Hour * 24 * 7)

func (ar *Auth) InsertRefreshToken(
	ctx context.Context,
	tx pgx.Tx,
	token string,
	user *user_model.User,
) error {
	cmd := `
	INSERT INTO refresh_tokens (user_id, token, expires_at) 
	VALUES($1, $2, $3)
	`
	args := []any{
		user.Id,
		token,
		ExpiresAt,
	}
	if tx == nil {
		_, err := ar.pgPool.Exec(ctx, cmd, args...)
		if err != nil {
			log.Println(err)
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

func (ar *Auth) GetRefreshToken(
	ctx context.Context,
	refreshToken string,
) (*auth_model.RefreshToken, error) {
	var rt auth_model.RefreshToken
	query := `SELECT id, user_id, token, expires_at from refresh_tokens WHERE token = $1`
	err := ar.pgPool.QueryRow(ctx, query, refreshToken).Scan(
		&rt.Id,
		&rt.UserID,
		&rt.Token,
		&rt.ExpiresAt,
	)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, errors.New("no token here")
	}
	return &rt, nil
}

func (ar *Auth) UpdateRefreshToken(ctx context.Context, userId string, newToken string) error {
	cmd := `UPDATE refresh_tokens SET token = $1, expires_at = $2 WHERE user_id = $3`
	args := []any{
		newToken,
		ExpiresAt,
		userId,
	}
	_, err := ar.pgPool.Exec(ctx, cmd, args...)
	if err != nil {
		return err
	}
	return nil
}
