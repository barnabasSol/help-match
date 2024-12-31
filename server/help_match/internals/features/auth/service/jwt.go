package service

import (
	"crypto/rand"
	"encoding/base64"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"hm.barney-host.site/internals/config"
	"hm.barney-host.site/internals/features/auth/dto"
	org_model "hm.barney-host.site/internals/features/organization/model"
	user_model "hm.barney-host.site/internals/features/users/model"
)

type claims struct {
	Username string `json:"username"`
	OrgId    string `json:"org_id,omitempty"`
	Role     string `json:"role"`
	jwt.RegisteredClaims
}

var jwtExpires = time.Now().Add(30 * time.Minute)

func generateJWT(userModel user_model.User, org *org_model.Organization) (string, error) {
	var claims claims
	if userModel.Role == string(dto.Organization) {
		claims.OrgId = org.Id
	}
	claims.Role = userModel.Role
	claims.Username = userModel.Username
	claims.RegisteredClaims = jwt.RegisteredClaims{
		Subject:   userModel.Id,
		ExpiresAt: jwt.NewNumericDate(jwtExpires),
		IssuedAt:  jwt.NewNumericDate(time.Now()),
		Issuer:    config.GetEnv("Iss"),
		Audience:  jwt.ClaimStrings{config.GetEnv("Aud")},
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString(([]byte(config.GetEnv("SECRET_KEY"))))
	if err != nil {
		return "", err
	}
	return tokenString, nil
}

func generateRefreshToken() (string, error) {
	tokenBytes := make([]byte, 32)
	_, err := rand.Read(tokenBytes)
	if err != nil {
		return "", err
	}
	refreshToken := base64.URLEncoding.EncodeToString(tokenBytes)
	return refreshToken, nil
}
