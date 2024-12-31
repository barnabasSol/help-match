package service

import (
	"context"

	"github.com/jackc/pgx/v5"
	"hm.barney-host.site/internals/features/organization/dto"
	"hm.barney-host.site/internals/features/organization/repository"
)

type Organization struct {
	orgRepo repository.OrgRepository
}

func NewOrgService(orgRepo repository.OrgRepository) *Organization {
	return &Organization{orgRepo}
}

func (os *Organization) GetOrganization(
	ctx context.Context,
	orgId string,
) (*dto.OrgResponseExtras, error) {
	var org dto.OrgResponseExtras
	org.Id = orgId
	err := os.orgRepo.WithTransaction(ctx, func(tx pgx.Tx) error {
		err := os.orgRepo.GetOrganization(ctx, tx, &org)
		if err != nil {
			return err
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	return &org, nil
}
