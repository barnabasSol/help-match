package repository

import (
	"context"
	"database/sql"
	"errors"

	"github.com/jackc/pgx/v5/pgxpool"
	"hm.barney-host.site/pkg/models"
)

type User struct {
	pgPool *pgxpool.Pool
}

func NewUserRepository(pool *pgxpool.Pool) *User {
	return &User{pool}
}

func (ur *User) Insert(ctx context.Context, user *models.User) error {
	query := `INSERT INTO users (name, username, email, password_hash)
	          VALUES ($1, $2, $3, $4)
	          RETURNING id, created_at, version`

	args := []any{user.Name, user.Username, user.Email, user.PasswordHash}
	return ur.pgPool.QueryRow(
		ctx,
		query,
		args,
	).Scan(
		&user.Id,
		&user.CreatedAt,
		&user.Version,
	)
}

func (ur *User) Delete(ctx context.Context, user *models.User) error {
	panic("")
}

func (ur *User) FindUserByUsername(ctx context.Context, username string) (*models.User, error) {
	var userModel models.User
	query := `SELCT id, name, username, created_at, activated, password_hash,
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
			return nil, ErrRecordNotFound
		} else {
			return nil, err
		}
	}
	return &userModel, nil
}
