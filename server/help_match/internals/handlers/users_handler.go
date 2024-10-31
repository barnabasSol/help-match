package handlers

import services "hm.barney-host.site/internals/services/users"

type UsersHandler struct {
	usersService *services.Users
}

func NewUsersService(usersService *services.Users) *UsersHandler {
	return &UsersHandler{usersService}
}
