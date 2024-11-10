package service

import (
	"crypto/rand"
	"encoding/base64"
	"log"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"hm.barney-host.site/internals/config"
	"hm.barney-host.site/internals/features/users/model"
)

type claims struct {
	Username string `json:"username"`
	UserID   string `json:"user_id"`
	jwt.RegisteredClaims
}

func generateJWT(userModel *model.User) (string, error) {
	claims := claims{
		Username: userModel.Username,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(15 * time.Minute)),
			Issuer:    config.GetConf("Iss"),
			Audience:  jwt.ClaimStrings{config.GetConf("Aud")},
		},
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString(([]byte(config.GetConf("SECRET_KEY"))))
	if err != nil {
		log.Println(err)
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
	refresToken := base64.URLEncoding.EncodeToString(tokenBytes)
	return refresToken, nil
}
