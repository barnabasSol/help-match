package utils

import (
	"fmt"

	"github.com/golang-jwt/jwt/v5"
	"hm.barney-host.site/internals/config"
)

type claimKeyType string

const ClaimsKey claimKeyType = "claimsKey"

type Claims struct {
	Username string `json:"username"`
	OrgId    string `json:"org_id,omitempty"`
	Role     string `json:"role"`
	jwt.RegisteredClaims
}

func ParseTokenClaims(tokenString string) (*Claims, error) {
	token, err := jwt.ParseWithClaims(tokenString, &Claims{}, func(t *jwt.Token) (any, error) {
		return []byte(config.GetEnv("SECRET_KEY")), nil
	})
	if err != nil {
		return nil, err
	}
	if claims, ok := token.Claims.(*Claims); ok && token.Valid {
		return claims, nil
	}
	return nil, fmt.Errorf("SOME NIL ERROR")
}
