package repository

import (
	"context"
	"database/sql"
	"errors"
	"fmt"

	"github.com/go-redis/redis/v8"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"hm.barney-host.site/internals/features/users/dto"
	user_errors "hm.barney-host.site/internals/features/users/errors"
	model "hm.barney-host.site/internals/features/users/model"
	"hm.barney-host.site/internals/features/utils"
)

type UserRepository interface {
	WithTransaction(ctx context.Context, fn func(pgx.Tx) error) error
	Insert(ctx context.Context, tx pgx.Tx, user *model.User) error
	FindUserByUsername(ctx context.Context, username string) (*model.User, error)
	FindUserById(ctx context.Context, userId string) (*model.User, error)
	UpdateUserInfo(ctx context.Context, userInfo dto.UpdateUserInfo, userId string) error
}

type User struct {
	pgPool      *pgxpool.Pool
	redisClient *redis.Client
}

func NewUserRepository(pool *pgxpool.Pool, redis *redis.Client) *User {
	return &User{pool, redis}
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
	query := `SELECT id, name, email, username, profile_pic_url, created_at, interests,
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
		&userModel.ProfilePicUrl,
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
	query := `SELECT id, name, email, username, profile_pic_url, created_at, interests,
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
		&userModel.ProfilePicUrl,
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
func (u *User) UpdateUserInfo(ctx context.Context, userInfo dto.UpdateUserInfo, userId string) error {
	err := utils.TransactionScope(ctx, u.pgPool, func(tx pgx.Tx) error {
		cmd := `
		UPDATE users
		SET
			name = COALESCE($1, name),
			username = COALESCE($2, username),
			email = COALESCE($3, email)
		WHERE id = $4;
	`
		args := []any{
			userInfo.Name,
			userInfo.Username,
			userInfo.Email,
			userId,
		}
		_, err := tx.Exec(ctx, cmd, args...)
		if err != nil {
			return err
		}

		if userInfo.Interests != nil {
			if len(userInfo.Interests.Add) > 0 {
				add_cmd := `UPDATE users SET interests = array_cat(interests, $1::interest_type[]) WHERE id = $2`
				_, err := tx.Exec(ctx, add_cmd, userInfo.Interests.Add, userId)
				if err != nil {
					return fmt.Errorf("failed to add interests: %w", err)
				}
			}

			if len(userInfo.Interests.Remove) > 0 {
				rm_cmd := `
				UPDATE users
				SET interests = array_remove(interests, unnest_element)
				FROM unnest($1::interest_type[]) AS unnest_element
				WHERE id = $2;`
				_, err := tx.Exec(ctx, rm_cmd, userInfo.Interests.Remove, userId)
				if err != nil {
					return fmt.Errorf("failed to remove interests: %w", err)
				}
			}
		}
		return nil
	})
	return err
}
