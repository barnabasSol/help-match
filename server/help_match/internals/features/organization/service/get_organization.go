package service

import (
	"context"

	"github.com/jackc/pgx/v5"
	"hm.barney-host.site/internals/features/organization/dto"
	"hm.barney-host.site/internals/features/organization/repository"
)

type OrgService struct {
	orgRepo repository.OrgRepository
}

func NewOrgService(orgRepo repository.OrgRepository) *OrgService {
	return &OrgService{orgRepo}
}

func (os *OrgService) GetOrganization(
	ctx context.Context,
	orgId string,
) (*dto.OrgResponseExtras, error) {
	var orgResponse dto.OrgResponseExtras
	orgResponse.Id = orgId
	err := os.orgRepo.WithTransaction(ctx, func(tx pgx.Tx) error {
		err := os.orgRepo.GetOrganization(ctx, nil, &orgResponse)
		if err != nil {
			return err
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	return &orgResponse, nil
}
