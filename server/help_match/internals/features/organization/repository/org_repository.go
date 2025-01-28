package repository

import (
	"context"
	"fmt"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/jackc/pgx/v5/pgxpool"
	geo "github.com/kellydunn/golang-geo"
	"hm.barney-host.site/internals/features/organization/dto"
	"hm.barney-host.site/internals/features/organization/model"
	"hm.barney-host.site/internals/features/utils"
)

type OrgRepository interface {
	WithTransaction(ctx context.Context, fn func(pgx.Tx) error) error
	Insert(ctx context.Context, tx pgx.Tx, orgModel *model.Organization, userId string) error
	GetOrganizationByOwnerId(ctx context.Context, tx pgx.Tx, userId string) (*model.Organization, error)
	GetOrganization(ctx context.Context, orgId string) (*model.Organization, error)
	GetOrganizationByJobId(ctx context.Context, jobId string) (*model.Organization, error)
	GetRecommendedOrgs(
		ctx context.Context,
		userId string,
		userLocation model.Location,
		orgParams dto.OrgParams,
	) ([]*dto.OrgListResponse, utils.Metadata, error)
	GetOrganizations(
		ctx context.Context,
		userId string,
		userLocation model.Location,
		orgParams dto.OrgParams,
	) ([]*dto.OrgListResponse, utils.Metadata, error)
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
	orgId string,
) (*model.Organization, error) {
	query := `
		SELECT id, user_id, organization_name, profile_icon, 
	    description, location, created_at, 
	    is_verified, version, org_type 
		FROM organizations 
		WHERE id = $1
	`

	row := or.pgPool.QueryRow(ctx, query, orgId)

	var org model.Organization
	var location pgtype.Point

	err := row.Scan(
		&org.Id,
		&org.UserId,
		&org.Name,
		&org.ProfileIcon,
		&org.Description,
		&location,
		&org.CreatedAt,
		&org.IsVerified,
		&org.Version,
		&org.Type,
	)

	if err != nil {
		return nil, fmt.Errorf("failed to fetch organization: %w", err)
	}

	org.Location = model.Location{
		Latitude:  location.P.X,
		Longitude: location.P.Y,
	}

	return &org, nil
}

func (o *Organization) GetOrganizations(
	ctx context.Context,
	userId string,
	userLocation model.Location,
	orgParams dto.OrgParams,
) ([]*dto.OrgListResponse, utils.Metadata, error) {
	var orgList []*dto.OrgListResponse
	query := fmt.Sprintf(`
		SELECT count(*) OVER() AS total_count, 
		organizations.id, organization_name, user_id, profile_icon, 
		description, is_verified, organizations.created_at, org_type, organizations.version, location
		FROM organizations JOIN users on users.id = organizations.user_id
		WHERE (organization_name ILIKE '%%' || $1 || '%%' OR $1 = '')
		AND (CASE WHEN $2 = '' THEN true ELSE org_type::text = $2 END)
		ORDER BY %s %s, organization_name ASC
		LIMIT $3 OFFSET $4`,
		orgParams.Filters.SortColumn(), orgParams.Filters.SortDirection(),
	)

	args := []any{
		orgParams.OrgName,
		orgParams.Type,
		orgParams.Filters.Limit(),
		orgParams.Filters.Offset(),
	}

	rows, err := o.pgPool.Query(ctx, query, args...)
	defer rows.Close()
	if err != nil {
		return nil, utils.Metadata{}, err
	}

	totalRecords := 0
	for rows.Next() {
		var orgModel dto.OrgListResponse
		var location pgtype.Point
		err := rows.Scan(
			&totalRecords,
			&orgModel.Id,
			&orgModel.Name,
			&orgModel.UserId,
			&orgModel.ProfileIcon,
			&orgModel.Description,
			&orgModel.IsVerified,
			&orgModel.CreatedAt,
			&orgModel.Type,
			&orgModel.Version,
			&location,
		)
		if err != nil {
			return nil, utils.Metadata{}, err
		}
		user_location := geo.NewPoint(userLocation.Latitude, userLocation.Longitude)
		org_location := geo.NewPoint(location.P.X, location.P.Y)

		orgModel.Proximity = user_location.GreatCircleDistance(org_location)
		orgList = append(orgList, &orgModel)
	}
	metadata := utils.CalculateMetadata(
		totalRecords,
		orgParams.Filters.Page,
		orgParams.Filters.PageSize,
	)
	return orgList, metadata, nil

}

func (or *Organization) GetOrganizationByOwnerId(
	ctx context.Context,
	tx pgx.Tx,
	ownerId string,
) (*model.Organization, error) {
	query := `SELECT id, organization_name, profile_icon, description,
		      location, created_at, updated_at, is_verified, version, org_type from organizations
			  WHERE user_id = $1`

	var row pgx.Row
	if tx != nil {
		row = tx.QueryRow(ctx, query, ownerId)
	} else if or.pgPool != nil {
		row = or.pgPool.QueryRow(ctx, query, ownerId)
	} else {
		return nil, fmt.Errorf("whattttttttttttttt")
	}
	var orgModel model.Organization
	var location pgtype.Point
	err := row.Scan(
		&orgModel.Id,
		&orgModel.Name,
		&orgModel.ProfileIcon,
		&orgModel.Description,
		&location,
		&orgModel.CreatedAt,
		&orgModel.UpdatedAt,
		&orgModel.IsVerified,
		&orgModel.Version,
		&orgModel.Type,
	)
	if err != nil {
		return nil, fmt.Errorf("omg?? couldnt scan")
	}
	orgModel.Location.Latitude = location.P.X
	orgModel.Location.Longitude = location.P.Y
	return &orgModel, nil
}

func (o *Organization) GetRecommendedOrgs(
	ctx context.Context,
	userId string,
	userLocation model.Location,
	orgParams dto.OrgParams,
) ([]*dto.OrgListResponse, utils.Metadata, error) {
	var orgList []*dto.OrgListResponse

	query := fmt.Sprintf(
		`SELECT count(*) OVER() as total_count, id, user_id, organization_name,
		 profile_icon, description, created_at, is_verified,
		 org_type, version, location from organizations
		 WHERE org_type::text = ANY(SELECT unnest(interests)::text FROM users where id = $1)
		 ORDER BY %s %s, organization_name ASC
		 LIMIT $2 OFFSET $3
		 `,
		orgParams.Filters.SortColumn(), orgParams.Filters.SortDirection(),
	)

	args := []any{
		userId,
		orgParams.Filters.Limit(),
		orgParams.Filters.Offset(),
	}
	rows, err := o.pgPool.Query(ctx, query, args...)
	if err != nil {
		return nil, utils.Metadata{}, err
	}

	totalRecords := 0
	for rows.Next() {
		var orgModel dto.OrgListResponse
		var location pgtype.Point
		err := rows.Scan(
			&totalRecords,
			&orgModel.Id,
			&orgModel.UserId,
			&orgModel.Name,
			&orgModel.ProfileIcon,
			&orgModel.Description,
			&orgModel.CreatedAt,
			&orgModel.IsVerified,
			&orgModel.Type,
			&orgModel.Version,
			&location,
		)
		user_location := geo.NewPoint(userLocation.Latitude, userLocation.Longitude)
		org_location := geo.NewPoint(location.P.X, location.P.Y)

		orgModel.Proximity = user_location.GreatCircleDistance(org_location)
		orgList = append(orgList, &orgModel)
		if err != nil {
			return nil, utils.Metadata{}, err
		}
	}
	metadata := utils.CalculateMetadata(
		totalRecords,
		orgParams.Filters.Page,
		orgParams.Filters.PageSize,
	)
	return orgList, metadata, nil
}

func (o *Organization) GetOrganizationByJobId(ctx context.Context, jobId string) (*model.Organization, error) {
	query := `SELECT organizations.id, organization_name, user_id, profile_icon, organizations.description,
			 is_verified, organizations.created_at, org_type, organizations.version, location
			 FROM organizations JOIN org_jobs ON organizations.id = org_jobs.org_id
			 WHERE org_jobs.id = $1`

	var orgModel model.Organization
	var location pgtype.Point
	err := o.pgPool.QueryRow(ctx, query, jobId).Scan(
		&orgModel.Id,
		&orgModel.Name,
		&orgModel.UserId,
		&orgModel.ProfileIcon,
		&orgModel.Description,
		&orgModel.IsVerified,
		&orgModel.CreatedAt,
		&orgModel.Type,
		&orgModel.Version,
		&location,
	)
	if err != nil {
		return nil, fmt.Errorf("failed to fetch organization: %w", err)
	}
	orgModel.Location = model.Location{
		Latitude:  location.P.X,
		Longitude: location.P.Y,
	}
	return &orgModel, nil
}
