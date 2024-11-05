package services

import (
	"crypto/rand"
	"encoding/base64"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"hm.barney-host.site/internals/config"
	"hm.barney-host.site/pkg/models"
)

func generateRefreshToken() (string, error) {
	tokenBytes := make([]byte, 32)
	_, err := rand.Read(tokenBytes)
	if err != nil {
		return "", err
	}
	refresToken := base64.URLEncoding.EncodeToString(tokenBytes)
	return refresToken, nil
}

func generateJWT(userModel *models.User) (string, error) {
	token := jwt.NewWithClaims(
		jwt.SigningMethodHS256,
		jwt.MapClaims{
			"username": userModel.Username,
			"iss":      "https://hm.barney-shot.site",
			"aud":      "com.barneyshot.hm",
			"exp":      time.Now().Add(time.Hour * 24).Unix(),
		},
	)
	tokenString, err := token.SignedString(config.GetConf("SECRET_KEY"))
	if err != nil {
		return "", err
	}
	return tokenString, nil
}
