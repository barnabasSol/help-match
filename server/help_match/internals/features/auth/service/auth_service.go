package service

import (
	"context"

	"github.com/jackc/pgx/v5"
	"hm.barney-host.site/internals/features/auth/dto"
	auth_errors "hm.barney-host.site/internals/features/auth/errors"
	auth_repo "hm.barney-host.site/internals/features/auth/repository"
	org_dto "hm.barney-host.site/internals/features/organization/dto"
	org_model "hm.barney-host.site/internals/features/organization/model"
	org_repo "hm.barney-host.site/internals/features/organization/repository"
	user_dto "hm.barney-host.site/internals/features/users/dto"
	"hm.barney-host.site/internals/features/users/model"
	user_repo "hm.barney-host.site/internals/features/users/repository"
)

type Auth struct {
	userRepo user_repo.UserRepository
	authRepo auth_repo.AuthRepository
	orgRepo  org_repo.OrgRepository
}

func NewAuthService(
	userRepo *user_repo.User,
	authRepo *auth_repo.Auth,
	orgRepo *org_repo.Organization,
) *Auth {
	return &Auth{userRepo, authRepo, orgRepo}
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

	if access_token, err = generateJWT(user, ""); err != nil {
		return nil, auth_errors.ErrFailedTokenGen
	}

	if refresh_token, err = generateRefreshToken(); err != nil {
		return nil, auth_errors.ErrFailedTokenGen
	}

	err = as.authRepo.InsertRefreshToken(ctx, nil, refresh_token, user)
	return &dto.Tokens{
		AccessToken:  access_token,
		RefreshToken: refresh_token,
	}, nil
}

func (as *Auth) Signup(
	ctx context.Context,
	signupDto dto.Signup,
) (*dto.SignupResponse, error) {

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
	var orgModel org_model.Organization

	var access_token string
	var refresh_token string

	err = as.authRepo.WithTransaction(ctx, func(tx pgx.Tx) error {
		err := as.userRepo.Insert(ctx, tx, &userModel)
		if err != nil {
			return err
		}

		if signupDto.IsOrganization {
			orgModel.Name = signupDto.OrgName
			orgModel.UserId = userModel.Id
			orgModel.Description = signupDto.Description
			orgModel.Location = org_model.Location(signupDto.Location)
			orgModel.Type = signupDto.Type

			if err := as.orgRepo.Insert(ctx, tx, &orgModel, userModel.Id); err != nil {
				return err
			}
		}
		access_token, err = generateJWT(&userModel, orgModel.Id)
		if err != nil {
			return auth_errors.ErrFailedTokenGen
		}

		refresh_token, err = generateRefreshToken()
		if err != nil {
			return auth_errors.ErrFailedTokenGen
		}

		if err := as.authRepo.InsertRefreshToken(ctx, tx, refresh_token, &userModel); err != nil {
			return err
		}

		return nil
	})
	if err != nil {
		return nil, err
	}
	var signupResponse dto.SignupResponse
	if !signupDto.IsOrganization {
		signupResponse.OrgResponse = nil
	} else {
		signupResponse.OrgResponse = &org_dto.OrgResponse{
			Name:        orgModel.Name,
			Location:    signupDto.Location,
			Description: signupDto.Description,
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
		CreatedAt:     userModel.CreatedAt,
		ProfilePicUrl: userModel.ProfilePicUrl,
		IsActivated:   userModel.IsActivated,
		Version:       userModel.Version,
	}
	return &signupResponse, nil
}
