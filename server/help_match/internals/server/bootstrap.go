package server

import (
	"github.com/jackc/pgx/v5/pgxpool"
	"hm.barney-host.site/internals/features/auth/handlers"
	auth_service "hm.barney-host.site/internals/features/auth/service"
	user_repository "hm.barney-host.site/internals/features/users/repository"
	user_service "hm.barney-host.site/internals/features/users/service"
)

func (as *AppServer) bootStrapHandlers(pool *pgxpool.Pool) {
	//repository
	userRepository := user_repository.NewUserRepository(pool)

	//services
	userService := user_service.NewUserService(userRepository)
	_ = userService
	authService := auth_service.NewAuthService(userRepository)

	//handlers
	as.authHandler = handlers.NewAuthHandler(authService)
}
