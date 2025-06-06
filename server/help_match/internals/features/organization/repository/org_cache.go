package repository

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"github.com/go-redis/redis/v8"
	"hm.barney-host.site/internals/features/organization/dto"
)

const orgsKey = "organizations:"
const expiry = 1 * time.Hour

func (o *Organization) CacheIsEmpty(ctx context.Context) (bool, error) {
	count, err := o.redisClient.SCard(ctx, orgsKey).Result()
	if err != nil {
		return false, fmt.Errorf("failed to check set cardinality: %w", err)
	}
	return count == 0, nil
}

func (o *Organization) AddToCache(ctx context.Context, org dto.OrgListResponse) error {
	orgJson, err := json.Marshal(org)
	if err != nil {
		return err
	}
	err = o.redisClient.Set(ctx, orgsKey+org.Id, orgJson, expiry).Err()
	if err != nil {
		return err
	}
	err = o.redisClient.SAdd(ctx, orgsKey, org.Id).Err()
	if err != nil {
		return fmt.Errorf("failed to add to set: %w", err)
	}
	return nil
}
func (o *Organization) GetCachedOrganizations(ctx context.Context, limit, offset int) ([]*dto.OrgListResponse, error) {
	orgIDs, err := o.redisClient.SMembers(ctx, orgsKey).Result()
	if err != nil {
		return nil, fmt.Errorf("failed to get org IDs: %w", err)
	}

	start := offset
	end := offset + limit
	if start > len(orgIDs) {
		return []*dto.OrgListResponse{}, nil
	}
	if end > len(orgIDs) {
		end = len(orgIDs)
	}
	paginatedIDs := orgIDs[start:end]

	var orgList []*dto.OrgListResponse
	for _, id := range paginatedIDs {
		orgJson, err := o.redisClient.Get(ctx, orgsKey+id).Result()
		if err == redis.Nil {
			o.redisClient.SRem(ctx, orgsKey, id)
			continue
		}
		if err != nil {
			fmt.Printf("Error retrieving org %s: %v\n", id, err)
			continue
		}

		var org dto.OrgListResponse
		if err := json.Unmarshal([]byte(orgJson), &org); err != nil {
			fmt.Printf("Error unmarshaling org %s: %v\n", id, err)
			continue
		}
		orgList = append(orgList, &org)
	}

	return orgList, nil
}
