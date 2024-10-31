package services

import "hm.barney-host.site/internals/repository"

type Auth struct {
	userRepo *repository.User
}

func NewAuthService(userRepo *repository.User) *Auth {
	return &Auth{userRepo}
}

func (as *Auth) Login() {

}

func (as *Auth) Signup() {

}
