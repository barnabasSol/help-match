package service

import (
	"context"

	"hm.barney-host.site/internals/features/organization/dto"
	"hm.barney-host.site/internals/features/organization/model"
	"hm.barney-host.site/internals/features/utils"
)

func (os *OrgService) GetOrganizations(
	ctx context.Context,
	orgParams dto.OrgParams,
	userId string,
	userLocation dto.Location,
) ([]*dto.OrgListResponse, utils.Metadata, error) {
	result, metadata, err := os.orgRepo.GetOrganizations(ctx, userId, model.Location(userLocation), orgParams)
	if err != nil {
		return nil, utils.Metadata{}, err
	}
	return result, metadata, nil

}
