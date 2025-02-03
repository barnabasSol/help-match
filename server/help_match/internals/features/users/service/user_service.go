package service

import (
	"context"

	"hm.barney-host.site/internals/features/auth/dto"
	auth_errors "hm.barney-host.site/internals/features/auth/errors"
	common "hm.barney-host.site/internals/features/common/dto"
	org_r "hm.barney-host.site/internals/features/organization/repository"
	"hm.barney-host.site/internals/features/users/repository"
)

type User struct {
	repo    repository.UserRepository
	orgRepo org_r.OrgRepository
}

func NewUserService(
	repo repository.UserRepository,
	orgRepo org_r.OrgRepository,
) *User {
	return &User{repo, orgRepo}
}

func (u *User) GetUserInfo(ctx context.Context, userId string) (*common.User, error) {
	user := new(common.User)
	usr, err := u.repo.FindUserById(ctx, userId)
	if err != nil {
		return nil, err
	}
	user = &common.User{
		Name:          usr.Name,
		Username:      usr.Username,
		Email:         usr.Email,
		ProfilePicUrl: usr.ProfilePicUrl,
		IsActivated:   usr.IsActivated,
		IsOnline:      *usr.IsOnline,
		Interests:     (*common.AllowedInterests)(&usr.Interests),
		CreatedAt:     usr.CreatedAt,
		Version:       usr.Version,
		OrgInfo:       nil,
	}
	if usr.Role == string(dto.User) {
		return user, nil
	} else if usr.Role == string(dto.Organization) {
		org, err := u.orgRepo.GetOrganizationByOwnerId(ctx, nil, userId)
		if err != nil {
			return nil, err
		}
		user.OrgInfo = &common.OrgInfo{
			Name:        org.Name,
			ProfileIcon: org.ProfileIcon,
			Description: org.Description,
			Location:    common.Location(org.Location),
			IsVerified:  org.IsVerified,
			CreatedAt:   org.CreatedAt,
			Type:        org.Type,
			Version:     org.Version,
		}
		return user, nil
	}
	return nil, auth_errors.ErrInvalidRole

}
