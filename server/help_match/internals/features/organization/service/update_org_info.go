package service

import (
	"context"

	"hm.barney-host.site/internals/features/organization/dto"
)

func (os *Organization) UpdateOrgInfo(
	ctx context.Context,
	orgId string,
	orgInfo dto.OrgInfoUpdateDto,
) error {
	err := os.orgRepo.UpdateOrgInfo(ctx, nil, orgInfo, orgId)
	return err
}
