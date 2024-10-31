package services

import "hm.barney-host.site/internals/repository"

type Users struct {
	usersRepo *repository.User
}

func NewUsersService(usersRepo *repository.User) *Users {
	return &Users{usersRepo}
}
