package repository

import (
	"context"
	"fmt"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"hm.barney-host.site/internals/features/organization/model"
	"hm.barney-host.site/internals/features/utils"
)

type OrgRepository interface {
	Insert(ctx context.Context, tx pgx.Tx, orgModel *model.Organization, userId string) error
	WithTransaction(ctx context.Context, fn func(pgx.Tx) error) error
}

type Organization struct {
	pgPool *pgxpool.Pool
}

func NewOrganizationRepository(pgPool *pgxpool.Pool) *Organization {
	return &Organization{pgPool}
}

func (or *Organization) WithTransaction(ctx context.Context, fn func(pgx.Tx) error) error {
	return utils.TransactionScope(ctx, or.pgPool, fn)
}

func (or *Organization) Insert(
	ctx context.Context,
	tx pgx.Tx,
	orgModel *model.Organization,
	userId string,
) error {
	query := `
	INSERT INTO organizations 
	(user_id, organization_name, description, location, org_type)
	VALUES ($1, $2, $3, POINT($4, $5), $6)
	RETURNING id, created_at, version, is_verified`

	args := []any{
		userId,
		orgModel.Name,
		orgModel.Description,
		orgModel.Location.Longitude,
		orgModel.Location.Latitude,
		orgModel.Type,
	}

	err := tx.QueryRow(ctx, query, args...).Scan(
		&orgModel.Id,
		&orgModel.CreatedAt,
		&orgModel.Version,
		&orgModel.IsVerified,
	)

	if err != nil {
		return fmt.Errorf("failed to insert organization: %w", err)
	}

	return nil
}
