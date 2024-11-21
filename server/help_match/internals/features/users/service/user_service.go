package service

import (
	"hm.barney-host.site/internals/features/users/repository"
)

type User struct {
	repo repository.UserRepository
}

func NewUserService(repo repository.UserRepository) *User {
	return &User{repo}
}

func (User) GetUsers() {
	// v := utils.NewValidator()

}
