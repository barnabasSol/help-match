package handlers

import services "hm.barney-host.site/internals/services/auth"

type Auth struct {
	authService *services.Auth
}

func NewAuthHandler(authService *services.Auth) *Auth {
	return &Auth{authService}
}
