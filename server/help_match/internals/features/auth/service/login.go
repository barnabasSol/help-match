package service

import (
	"context"

	"hm.barney-host.site/internals/features/auth/dto"
	auth_errors "hm.barney-host.site/internals/features/auth/errors"
	"hm.barney-host.site/internals/features/organization/model"
)

func (as *Auth) Login(
	ctx context.Context,
	loginDto dto.Login,
) (*dto.Tokens, error) {
	err := loginDto.Validate()
	if err != nil {
		return nil, err
	}
	user, err := as.userRepo.FindUserByUsername(ctx, loginDto.Username)
	if err != nil {
		return nil, err
	}
	var psw password
	psw.hash = user.PasswordHash
	if ok, err := psw.Matches(loginDto.Password); !ok {
		return nil, err
	}
	var org *model.Organization
	if user.Role == string(dto.Organization) {
		org, err = as.orgRepo.GetOrganizationByOwnerId(ctx, nil, user.Id)
		if err != nil {
			return nil, err
		}
	}

	var access_token string
	var refresh_token string

	if access_token, err = generateJWT(*user, org); err != nil {
		return nil, auth_errors.ErrFailedTokenGen
	}

	if refresh_token, err = generateRefreshToken(); err != nil {
		return nil, auth_errors.ErrFailedTokenGen
	}

	err = as.authRepo.InsertRefreshToken(ctx, nil, refresh_token, user)
	if err != nil {
		return nil, err
	}
	return &dto.Tokens{
		AccessToken:  access_token,
		RefreshToken: refresh_token,
	}, nil
}
