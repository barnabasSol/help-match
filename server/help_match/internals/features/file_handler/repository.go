package filehandler

import (
	"context"

	"github.com/jackc/pgx/v5/pgxpool"
)

type FileHandlerRepository interface {
	UpdateOrgProfile(ctx context.Context, filePath, userId string) error
	UpdateProfile(ctx context.Context, filePath, userId string) error
	InsertPost(ctx context.Context, filePath, orgId string) error
}

type FileHandler struct {
	pool *pgxpool.Pool
}

func NewFileHandlerRepository(pool *pgxpool.Pool) *FileHandler {
	return &FileHandler{pool}
}

func (f *FileHandler) UpdateProfile(ctx context.Context, path, userId string) error {
	query := `UPDATE users SET profile_pic_url = $1 WHERE id = $2`
	_, err := f.pool.Exec(ctx, query, path, userId)
	return err
}

func (f *FileHandler) UpdateOrgProfile(ctx context.Context, path, userId string) error {
	query := `UPDATE organiztions SET profile_icon = $1 WHERE id = $2`
	_, err := f.pool.Exec(ctx, query, path, userId)
	return err
}
func (f *FileHandler) InsertPost(ctx context.Context, path, orgId string) error {
	query := `
		UPDATE organizations
		SET image_posts = ARRAY_APPEND(image_posts, $1)
		WHERE id = $2;
		`
	_, err := f.pool.Exec(ctx, query, path, orgId)
	return err
}
