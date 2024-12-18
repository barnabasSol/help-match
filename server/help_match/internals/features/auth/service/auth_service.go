package service

import (
	auth_repo "hm.barney-host.site/internals/features/auth/repository"
	org_repo "hm.barney-host.site/internals/features/organization/repository"
	user_repo "hm.barney-host.site/internals/features/users/repository"
)

type Auth struct {
	userRepo user_repo.UserRepository
	authRepo auth_repo.AuthRepository
	orgRepo  org_repo.OrgRepository
}

func NewAuthService(
	userRepo *user_repo.User,
	authRepo *auth_repo.Auth,
	orgRepo *org_repo.Organization,
) *Auth {
	return &Auth{userRepo, authRepo, orgRepo}
}
