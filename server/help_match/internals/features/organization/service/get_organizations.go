package service

import (
	"context"
	"sort"

	geo "github.com/kellydunn/golang-geo"
	"hm.barney-host.site/internals/features/organization/dto"
	"hm.barney-host.site/internals/features/organization/model"
	"hm.barney-host.site/internals/features/utils"
)

func (os *Organization) GetOrganizations(
	ctx context.Context,
	orgParams dto.OrgParams,
	userId string,
	userLocation dto.Location,
) ([]*dto.OrgListResponse, utils.Metadata, error) {
	result, metadata, err := os.orgRepo.GetOrganizations(
		ctx,
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

func calculateDistance(user, org dto.Location) float64 {
	p := geo.NewPoint(user.Latitude, user.Longitude)
	p2 := geo.NewPoint(org.Latitude, org.Longitude)

	dist := p.GreatCircleDistance(p2)
	return dist
}
