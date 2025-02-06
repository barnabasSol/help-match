package repository

import (
	"context"
	"database/sql"
	"errors"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	user_errors "hm.barney-host.site/internals/features/users/errors"
	model "hm.barney-host.site/internals/features/users/model"
	"hm.barney-host.site/internals/features/utils"
)

type UserRepository interface {
	WithTransaction(ctx context.Context, fn func(pgx.Tx) error) error
	Insert(ctx context.Context, tx pgx.Tx, user *model.User) error
	FindUserByUsername(ctx context.Context, username string) (*model.User, error)
	FindUserById(ctx context.Context, userId string) (*model.User, error)
}

type User struct {
	pgPool *pgxpool.Pool
}

func NewUserRepository(pool *pgxpool.Pool) *User {
	return &User{pool}
}

func (ur *User) WithTransaction(ctx context.Context, fn func(pgx.Tx) error) error {
	return utils.TransactionScope(ctx, ur.pgPool, fn)
}
func (ur *User) Insert(ctx context.Context, tx pgx.Tx, user *model.User) error {
	query := `INSERT INTO users (name, username, email, password_hash, user_role, interests)
			  VALUES ($1, $2, $3, $4, $5, $6::interest_type[])
			  RETURNING id, created_at, version, user_role, activated`
	args := []any{
		user.Name,
		user.Username,
		user.Email,
		user.PasswordHash,
		user.Role,
		user.Interests,
	}

	err := tx.QueryRow(ctx, query, args...).Scan(
		&user.Id,
		&user.CreatedAt,
		&user.Version,
		&user.Role,
		&user.IsActivated,
	)

	if err != nil {
		return err
	}
	return nil
}

func (ur *User) Delete(ctx context.Context, user *model.User) error {
	panic("")
}

func (ur *User) FindUserByUsername(
	ctx context.Context,
	username string,
) (*model.User, error) {
	var userModel model.User
	query := `SELECT id, name, email, username, created_at, interests,
   			  activated, is_online, password_hash, user_role, version
			  FROM users where username = $1`

	err := ur.pgPool.QueryRow(
		ctx,
		query,
		username,
	).Scan(
		&userModel.Id,
		&userModel.Name,
		&userModel.Email,
		&userModel.Username,
		&userModel.CreatedAt,
		&userModel.Interests,
		&userModel.IsActivated,
		&userModel.IsOnline,
		&userModel.PasswordHash,
		&userModel.Role,
		&userModel.Version,
	)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, user_errors.ErrRecordNotFound
		} else {
			return nil, err
		}
	}
	return &userModel, nil
}

func (ur *User) FindUserById(
	ctx context.Context,
	userId string,
) (*model.User, error) {
	var userModel model.User
	query := `SELECT id, name, email, username, created_at, interests,
   			  activated, is_online, password_hash, user_role, version
			  FROM users where id = $1`

	err := ur.pgPool.QueryRow(
		ctx,
		query,
		userId,
	).Scan(
		&userModel.Id,
		&userModel.Name,
		&userModel.Email,
		&userModel.Username,
		&userModel.CreatedAt,
		&userModel.Interests,
		&userModel.IsActivated,
		&userModel.IsOnline,
		&userModel.PasswordHash,
		&userModel.Role,
		&userModel.Version,
	)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, user_errors.ErrRecordNotFound
		} else {
			return nil, err
		}
	}
	return &userModel, nil
}
