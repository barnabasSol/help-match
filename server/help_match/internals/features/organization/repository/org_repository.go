package repository

import (
	"context"
	"fmt"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/jackc/pgx/v5/pgxpool"
	"hm.barney-host.site/internals/features/organization/dto"
	"hm.barney-host.site/internals/features/organization/model"
	"hm.barney-host.site/internals/features/utils"
)

type OrgRepository interface {
	WithTransaction(ctx context.Context, fn func(pgx.Tx) error) error
	Insert(ctx context.Context, tx pgx.Tx, orgModel *model.Organization, userId string) error
	GetOrganization(ctx context.Context, tx pgx.Tx, orgResponse *dto.OrgResponseExtras) error
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
		RETURNING id, created_at, version, is_verified
	`

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

func (or *Organization) GetOrganization(
	ctx context.Context,
	tx pgx.Tx,
	orgResponse *dto.OrgResponseExtras,
) error {
	query := `
		SELECT organizations.id, user_id, organization_name, profile_icon, 
	    description, location, organizations.created_at, 
	    is_verified, organizations.version, org_type 
		FROM organizations 
		JOIN users ON users.id = organizations.user_id 
		WHERE organizations.id = $1
	`

	var row pgx.Row
	if tx != nil {
		row = tx.QueryRow(ctx, query, orgResponse.Id)
	} else if or.pgPool != nil {
		row = or.pgPool.QueryRow(ctx, query, orgResponse.Id)
	} else {
		return fmt.Errorf("whattttttttttttttt")
	}

	var location pgtype.Point
	err := row.Scan(
		&orgResponse.Id,
		&orgResponse.UserId,
		&orgResponse.Name,
		&orgResponse.ProfileIcon,
		&orgResponse.Description,
		&location,
		&orgResponse.CreatedAt,
		&orgResponse.IsVerified,
		&orgResponse.Version,
		&orgResponse.Type,
	)

	orgResponse.Location.Latitude = location.P.X
	orgResponse.Location.Longitude = location.P.Y

	if err != nil {
		return fmt.Errorf("yeahhh it failed to fetch: %w", err)
	}

	return nil
}
