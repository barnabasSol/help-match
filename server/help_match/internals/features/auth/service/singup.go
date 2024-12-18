package service

import (
	"context"

	"github.com/jackc/pgx/v5"
	"hm.barney-host.site/internals/features/auth/dto"
	auth_errors "hm.barney-host.site/internals/features/auth/errors"
	org_dto "hm.barney-host.site/internals/features/organization/dto"
	org_model "hm.barney-host.site/internals/features/organization/model"
	user_dto "hm.barney-host.site/internals/features/users/dto"
	"hm.barney-host.site/internals/features/users/model"
)

func (as *Auth) Signup(
	ctx context.Context,
	signupDto dto.Signup,
) (*dto.SignupResponse, error) {
	err := signupDto.Validate()
	if err != nil {
		return nil, err
	}
	var ps password
	err = ps.Set(signupDto.Password)
	if err != nil {
		return nil, err
	}
	userModel := model.User{
		Username:     signupDto.Username,
		Name:         signupDto.Name,
		Email:        signupDto.Email,
		PasswordHash: ps.hash,
		Role:         string(signupDto.Role),
	}

	if signupDto.Role == dto.User {
		userModel.Interests = *signupDto.Interests
	}
	var orgModel org_model.Organization

	var access_token string
	var refresh_token string

	err = as.authRepo.WithTransaction(ctx, func(tx pgx.Tx) error {
		err := as.userRepo.Insert(ctx, tx, &userModel)
		if err != nil {
			return err
		}

		if signupDto.Role == dto.Organization {
			orgModel.Name = signupDto.OrgInfo.OrgName
			orgModel.UserId = userModel.Id
			orgModel.Description = signupDto.OrgInfo.Description
			orgModel.Location = org_model.Location(signupDto.OrgInfo.Location)
			orgModel.Type = signupDto.OrgInfo.Type

			if err := as.orgRepo.Insert(
				ctx,
				tx,
				&orgModel,
				userModel.Id,
			); err != nil {
				return err
			}
		}
		access_token, err = generateJWT(userModel, &orgModel)
		if err != nil {
			return auth_errors.ErrFailedTokenGen
		}

		refresh_token, err = generateRefreshToken()
		if err != nil {
			return auth_errors.ErrFailedTokenGen
		}

		if err := as.authRepo.InsertRefreshToken(
			ctx,
			tx,
			refresh_token,
			&userModel,
		); err != nil {
			return err
		}

		return nil
	})
	if err != nil {
		return nil, err
	}

	var signupResponse dto.SignupResponse

	if signupDto.Role != dto.Organization {
		signupResponse.OrgResponse = nil
		signupResponse.User.Interests = nil
	} else {
		signupResponse.OrgResponse = &org_dto.OrgResponse{
			Name:        orgModel.Name,
			Location:    signupDto.OrgInfo.Location,
			Description: signupDto.OrgInfo.Description,
			Version:     orgModel.Version,
			CreatedAt:   orgModel.CreatedAt,
			IsVerified:  orgModel.IsVerified,
			Type:        signupDto.OrgInfo.Type,
		}
	}

	signupResponse.Tokens = dto.Tokens{
		AccessToken:  access_token,
		RefreshToken: refresh_token,
	}

	signupResponse.User = user_dto.User{
		Name:          userModel.Name,
		Username:      userModel.Username,
		Email:         userModel.Email,
		Interests:     (*user_dto.AllowedInterests)(signupDto.Interests),
		CreatedAt:     userModel.CreatedAt,
		ProfilePicUrl: userModel.ProfilePicUrl,
		IsActivated:   userModel.IsActivated,
		Version:       userModel.Version,
	}
	return &signupResponse, nil
}
