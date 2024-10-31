package repository

import (
	"github.com/jackc/pgx/v5/pgxpool"
)

type User struct {
	pgPool *pgxpool.Pool
}

func NewUserRepository(pool *pgxpool.Pool) *User {
	return &User{pool}
}

func (ur *User) Insert(user User) error {
	panic("not implemented")
}
