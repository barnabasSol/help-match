package filehandler

import (
	"context"

	"github.com/jackc/pgx/v5/pgxpool"
)

type FileHandlerRepository interface {
	Profile(ctx context.Context, filePath string)
	Post(ctx context.Context, filePath string)
}

type FileHandler struct {
	pool *pgxpool.Pool
}

func NewFileHandlerRepository(pool *pgxpool.Pool) *FileHandler {
	return &FileHandler{pool}
}

func Profile(ctx context.Context, filePath string) {

}

func Post(ctx context.Context, filePath string) {
}
