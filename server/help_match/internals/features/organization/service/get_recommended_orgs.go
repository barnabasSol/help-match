package service

import (
	"context"
	"sort"

	"hm.barney-host.site/internals/features/organization/dto"
	"hm.barney-host.site/internals/features/organization/model"
	"hm.barney-host.site/internals/features/utils"
)

func (os *Organization) GetRecommendedOrgs(
	ctx context.Context,
	userId string,
	userLocation dto.Location,
	orgParams dto.OrgParams,
) ([]*dto.OrgListResponse, utils.Metadata, error) {
	result, metadata, err := os.orgRepo.GetRecommendedOrgs(
		ctx,
		userId,
		model.Location(userLocation),
		orgParams,
	)
	if err != nil {
		return nil, utils.Metadata{}, err
	}
	for _, org := range result {
		org.Proximity = calculateDistance(userLocation, *org.Location)
		org.Location = nil
	}
	if orgParams.Filters.Sort == "proximity" {
		sort.Slice(result, func(i, j int) bool {
			return result[i].Proximity < result[j].Proximity
		})
	} else if orgParams.Filters.Sort == "-proximity" {
		sort.Slice(result, func(i, j int) bool {
			return result[i].Proximity > result[j].Proximity
		})
	}

	return result, metadata, nil
}
