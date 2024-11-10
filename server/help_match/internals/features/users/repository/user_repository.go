package repository

import (
	"context"
	"database/sql"
	"errors"

	"github.com/jackc/pgx/v5/pgxpool"
	user_errors "hm.barney-host.site/internals/features/users/errors"
	model "hm.barney-host.site/internals/features/users/model"
)

type UserRepository interface {
	Insert(ctx context.Context, user *model.User) error
	FindUserByUsername(ctx context.Context, username string) (*model.User, error)
	// WithTx(ctx context.Context, fn func(pgx.Tx) error) error
}

type User struct {
	pgPool *pgxpool.Pool
}

func NewUserRepository(pool *pgxpool.Pool) *User {
	return &User{pool}
}

// func (ur *User) WithTx(ctx context.Context, fn func(pgx.Tx) error) error {
// 	tx, err := ur.pgPool.BeginTx(ctx, pgx.TxOptions{})
// 	if err != nil {
// 		return fmt.Errorf("failed to begin transaction: %w", err)
// 	}
// 	defer tx.Rollback(ctx)

// 	if err := fn(tx); err != nil {
// 		return err
// 	}

// 	if err := tx.Commit(ctx); err != nil {
// 		return fmt.Errorf("failed to commit transaction: %w", err)
// 	}

// 	return nil
// }

func (ur *User) Insert(ctx context.Context, user *model.User) error {
	query := `INSERT INTO users (name, username, email, password_hash, is_organization)
             VALUES ($1, $2, $3, $4, $5)
             RETURNING id, created_at, version, is_organization, activated`
	args := []any{user.Name, user.Username, user.Email, user.PasswordHash, user.IsOrganization}
	return ur.pgPool.QueryRow(ctx, query, args...).Scan(
		&user.Id,
		&user.CreatedAt,
		&user.Version,
		&user.IsOrganization,
		&user.IsActivated,
	)
}

func (ur *User) Delete(ctx context.Context, user *model.User) error {
	panic("")
}

func (ur *User) FindUserByUsername(ctx context.Context, username string) (*model.User, error) {
	var userModel model.User
	query := `SELECT id, name, username, created_at, activated, password_hash,
			  email FROM users where username = $1`
	err := ur.pgPool.QueryRow(
		ctx,
		query,
		username,
	).Scan(
		&userModel.Id,
		&userModel.Name,
		&userModel.Username,
		&userModel.CreatedAt,
		&userModel.IsActivated,
		&userModel.PasswordHash,
		&userModel.Email,
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
