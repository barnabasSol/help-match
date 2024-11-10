package service

import (
	"context"
	"errors"

	"hm.barney-host.site/internals/features/auth/dto"
	auth_dto "hm.barney-host.site/internals/features/auth/dto"
	auth_errors "hm.barney-host.site/internals/features/auth/errors"
	user_dto "hm.barney-host.site/internals/features/users/dto"
	"hm.barney-host.site/internals/features/users/model"
	"hm.barney-host.site/internals/features/users/repository"
)

type Auth struct {
	userRepo repository.UserRepository
}

func NewAuthService(userRepo *repository.User) *Auth {
	return &Auth{userRepo}
}

func (as *Auth) Login(
	ctx context.Context,
	loginDto dto.Login,
) (*dto.Tokens, error) {
	user, err := as.userRepo.FindUserByUsername(ctx, loginDto.Username)
	if err != nil {
		return nil, err
	}
	var psw password
	psw.hash = user.PasswordHash
	if ok, err := psw.Matches(loginDto.Password); !ok {
		return nil, err
	}

	var access_token string
	var refresh_token string

	if access_token, err = generateJWT(user); err != nil {
		return nil, auth_errors.ErrFailedTokenGen
	}

	if refresh_token, err = generateRefreshToken(); err != nil {
		return nil, auth_errors.ErrFailedTokenGen
	}
	return &dto.Tokens{
		AccessToken:  access_token,
		RefreshToken: refresh_token,
	}, nil
}

func (as *Auth) Signup(
	ctx context.Context,
	signupDto dto.Signup,
) (*dto.SignupResponse, error) {
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
	userModel := model.User{
		Username:       signupDto.Username,
		ProfilePicUrl:  signupDto.ProfilePicUrl,
		Name:           signupDto.Name,
		Email:          signupDto.Email,
		PasswordHash:   ps.hash,
		IsOrganization: signupDto.IsOrganization,
	}

	err = as.userRepo.Insert(ctx, &userModel)

	if err != nil {
		return nil, err
	}
	var access_token string
	var refresh_token string

	if access_token, err = generateJWT(&userModel); err != nil {
		return nil, auth_errors.ErrFailedTokenGen
	}

	if refresh_token, err = generateRefreshToken(); err != nil {
		return nil, auth_errors.ErrFailedTokenGen
	}
	signUpResponse := dto.SignupResponse{
		Tokens: auth_dto.Tokens{
			AccessToken:  access_token,
			RefreshToken: refresh_token,
		},
		User: user_dto.User{
			Name:           userModel.Name,
			Username:       userModel.Username,
			Email:          userModel.Email,
			CreatedAt:      userModel.CreatedAt,
			ProfilePicUrl:  userModel.ProfilePicUrl,
			IsActivated:    userModel.IsActivated,
			IsOrganization: userModel.IsOrganization,
			Version:        userModel.Version,
		},
	}

	return &signUpResponse, nil
}
