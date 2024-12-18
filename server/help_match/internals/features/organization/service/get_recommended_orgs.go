package service

import (
	"context"

	"hm.barney-host.site/internals/features/organization/dto"
	"hm.barney-host.site/internals/features/organization/model"
	"hm.barney-host.site/internals/features/utils"
)

func (os *OrgService) GetRecommendedOrgs(
	ctx context.Context,
	userId string,
	userLocation dto.Location,
	orgParams dto.OrgParams,
) ([]*dto.OrgListResponse, utils.Metadata, error) {
	result, metadata, err := os.orgRepo.GetRecommendedOrgs(ctx, userId, model.Location(userLocation), orgParams)
	if err != nil {
		return nil, utils.Metadata{}, err
	}
	return result, metadata, nil
}
