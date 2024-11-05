package services

import (
	"context"
	"errors"

	"hm.barney-host.site/internals/repository"
	"hm.barney-host.site/pkg/dtos"
	"hm.barney-host.site/pkg/models"
)

type Auth struct {
	userRepo *repository.User
}

func NewAuthService(userRepo *repository.User) *Auth {
	return &Auth{userRepo}
}

func (as *Auth) Login(
	ctx context.Context,
	loginDto dtos.Login,
) (*dtos.Tokens, error) {
	user, err := as.userRepo.FindUserByUsername(ctx, loginDto.Username)
	if err != nil {
		switch err {
		case repository.ErrRecordNotFound:
			return nil, ErrUserDoesntExist
		default:
			return nil, err
		}
	}
	var psw password
	psw.hash = user.PasswordHash
	if ok, err := psw.Matches(loginDto.Password); !ok {
		return nil, err
	}

	var access_token string
	var refresh_token string

	if access_token, err = generateJWT(user); err != nil {
		return nil, ErrFailedTokenGen
	}

	if refresh_token, err = generateRefreshToken(); err != nil {
		return nil, ErrFailedTokenGen
	}
	return &dtos.Tokens{
		AccessToken:  access_token,
		RefreshToken: refresh_token,
	}, nil
}

func (as *Auth) Signup(
	ctx context.Context,
	signupDto dtos.Signup,
) (*models.User, error) {
	if signupDto.Name == "" {
		return nil, errors.New("name is required")
	}
	if signupDto.Username == "" {
		return nil, errors.New("username is required")
	}
	if signupDto.Email == "" {
		return nil, errors.New("email is required")
	}
	if signupDto.Password == "" {
		return nil, errors.New("password is required")
	}
	var ps password
	err := ps.Set(signupDto.Password)
	if err != nil {
		return nil, err
	}
	userModel := models.User{
		Username:     signupDto.Username,
		Name:         signupDto.Name,
		Email:        signupDto.Email,
		PasswordHash: ps.hash,
	}
	err = as.userRepo.Insert(ctx, &userModel)
	if err != nil {
		return nil, err
	}
	return &userModel, nil
}
