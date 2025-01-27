package service

import (
	auth_repo "hm.barney-host.site/internals/features/auth/repository"
	org_repo "hm.barney-host.site/internals/features/organization/repository"
	user_repo "hm.barney-host.site/internals/features/users/repository"
	"hm.barney-host.site/internals/server/ws"
)

type Auth struct {
	wsManager *ws.Manager
	userRepo  user_repo.UserRepository
	authRepo  auth_repo.AuthRepository
	orgRepo   org_repo.OrgRepository
}

func NewAuthService(
	userRepo user_repo.UserRepository,
	authRepo auth_repo.AuthRepository,
	orgRepo org_repo.OrgRepository,
	wsManager *ws.Manager,
) *Auth {
	return &Auth{wsManager, userRepo, authRepo, orgRepo}
}
