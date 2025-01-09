package middleware

import (
	"context"
	"errors"
	"log"
	"net/http"

	"github.com/golang-jwt/jwt/v5"
	"github.com/julienschmidt/httprouter"
	"hm.barney-host.site/internals/config"
	"hm.barney-host.site/internals/features/utils"
)

func AuthMiddleware(next httprouter.Handle) httprouter.Handle {
	return func(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
		tokenString := r.Header.Get("Authorization")
		if len(tokenString) > 7 && tokenString[:7] == "Bearer " {
			tokenString = tokenString[7:]
		} else {
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			log.Println("Invalid Authorization header format")
			return
		}
		authorized := checkAuth(tokenString)
		if !authorized {
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			return
		}
		claims, err := utils.ParseTokenClaims(tokenString)
		if err != nil {
			http.Error(w, "Maybe you gave some bullshit claims, you bad boy", http.StatusUnauthorized)
			return
		}
		ctx := context.WithValue(r.Context(), utils.ClaimsKey, *claims)
		r = r.WithContext(ctx)
		next(w, r, ps)
	}
}

func checkAuth(tokenString string) bool {
	token, err := jwt.Parse(
		tokenString,
		func(token *jwt.Token) (any, error) {
			return []byte(config.GetEnv("SECRET_KEY")), nil
		},
		jwt.WithValidMethods([]string{"HS256"}),
		jwt.WithAudience(config.GetEnv("Aud")),
		jwt.WithIssuer(config.GetEnv("Iss")),
	)
	switch {
	case token.Valid:
		return true
	case errors.Is(err, jwt.ErrTokenMalformed):
		log.Println("That's not even a token")
	case errors.Is(err, jwt.ErrTokenSignatureInvalid):
		log.Println("Invalid signature")
	case errors.Is(err, jwt.ErrTokenExpired) || errors.Is(err, jwt.ErrTokenNotValidYet):
		log.Println("Timing is everything")
	default:
		log.Println("Couldn't handle this token:", err)
	}
	return false
}
