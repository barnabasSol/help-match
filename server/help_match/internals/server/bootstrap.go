package server

import (
	"github.com/jackc/pgx/v5/pgxpool"
	"hm.barney-host.site/internals/handlers"
	"hm.barney-host.site/internals/repository"
	auth_services "hm.barney-host.site/internals/services/auth"
	user_services "hm.barney-host.site/internals/services/users"
)

func (as *AppServer) bootStrapHandlers(pool *pgxpool.Pool) {
	//repository
	userRepository := repository.NewUserRepository(pool)
	//services
	userService := user_services.NewUsersService(userRepository)
	_ = userService
	authService := auth_services.NewAuthService(userRepository)
	//handlers
	as.authHandler = handlers.NewAuthHandler(authService)
}
