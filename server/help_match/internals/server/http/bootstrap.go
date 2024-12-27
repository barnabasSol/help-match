package server

import (
	"github.com/jackc/pgx/v5/pgxpool"
	auth_h "hm.barney-host.site/internals/features/auth/handler"
	auth_r "hm.barney-host.site/internals/features/auth/repository"
	auth_s "hm.barney-host.site/internals/features/auth/service"
	org_h "hm.barney-host.site/internals/features/organization/handler"
	org_r "hm.barney-host.site/internals/features/organization/repository"
	org_s "hm.barney-host.site/internals/features/organization/service"
	user_r "hm.barney-host.site/internals/features/users/repository"
)

func (as *AppServer) bootstrapHandlers(pool *pgxpool.Pool) {
	//repository
	userRepo := user_r.NewUserRepository(pool)
	authRepo := auth_r.NewAuthRepository(pool)
	orgRepo := org_r.NewOrganizationRepository(pool)

	//services
	// userService := user_service.NewUserService(userRepo)
	authService := auth_s.NewAuthService(userRepo, authRepo, orgRepo, as.wsManager)
	orgService := org_s.NewOrgService(orgRepo)

	//handlers
	as.authHandler = auth_h.NewAuthHandler(authService)
	as.orgHandler = org_h.NewOrgHandler(orgService)
}
