package server

import (
	"github.com/jackc/pgx/v5/pgxpool"
	auth_hand "hm.barney-host.site/internals/features/auth/handler"
	auth_repo "hm.barney-host.site/internals/features/auth/repository"
	auth_service "hm.barney-host.site/internals/features/auth/service"
	org_h "hm.barney-host.site/internals/features/organization/handler"
	org_repo "hm.barney-host.site/internals/features/organization/repository"
	org_service "hm.barney-host.site/internals/features/organization/service"
	user_repository "hm.barney-host.site/internals/features/users/repository"
)

func (as *AppServer) bootStrapHandlers(pool *pgxpool.Pool) {
	//repository
	userRepo := user_repository.NewUserRepository(pool)
	authRepo := auth_repo.NewAuthRepository(pool)
	orgRepo := org_repo.NewOrganizationRepository(pool)

	//services
	// userService := user_service.NewUserService(userRepo)
	authService := auth_service.NewAuthService(userRepo, authRepo, orgRepo)
	orgService := org_service.NewOrgService(orgRepo)

	//handlers
	as.authHandler = auth_hand.NewAuthHandler(authService)
	as.orgHandler = org_h.NewOrgHandler(orgService)
}
