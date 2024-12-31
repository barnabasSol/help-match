package service

import (
	"context"
	"time"

	"hm.barney-host.site/internals/features/auth/dto"
	auth_errors "hm.barney-host.site/internals/features/auth/errors"
	"hm.barney-host.site/internals/features/organization/model"
)

func (as *Auth) RenewToken(
	ctx context.Context,
	incommingToken, username string,
) (*dto.Tokens, error) {
	token, err := as.authRepo.GetRefreshToken(ctx, incommingToken)
	if err != nil {
		return nil, err
	}
	if time.Now().After(token.ExpiresAt) {
		return nil, auth_errors.ErrExpiredRefreshToken
	}
	user, err := as.userRepo.FindUserByUsername(ctx, username)
	if err != nil {
		return nil, auth_errors.ErrUserDoesntExist
	}
	var org *model.Organization
	if user.Role == string(dto.Organization) {
		org, err = as.orgRepo.GetOrganizationByOwnerId(ctx, nil, user.Id)
		if err != nil {
			return nil, err
		}
	}

	if token.UserID != user.Id {
		return nil, auth_errors.ErrInvalidRefreshTokenOwner
	}

	var access_token string
	var refresh_token string

	if access_token, err = generateJWT(*user, org); err != nil {
		return nil, auth_errors.ErrFailedTokenGen
	}

	if refresh_token, err = generateRefreshToken(); err != nil {
		return nil, auth_errors.ErrFailedTokenGen
	}

	err = as.authRepo.UpdateRefreshToken(ctx, user.Id, refresh_token)
	if err != nil {
		return nil, err
	}

	return &dto.Tokens{
		AccessToken:  access_token,
		RefreshToken: refresh_token,
		OTP:          as.wsManager.Otps.NewOTP().Key,
	}, nil

}
