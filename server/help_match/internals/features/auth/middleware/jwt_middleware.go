package middleware

import (
	"errors"
	"log"
	"net/http"

	"github.com/golang-jwt/jwt/v5"
	"github.com/julienschmidt/httprouter"
	"hm.barney-host.site/internals/config"
)

func AuthMiddleware(next httprouter.Handle) httprouter.Handle {
	return func(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
		authorized := checkAuth(r)
		if !authorized {
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			return
		}

		next(w, r, ps)
	}
}

func checkAuth(r *http.Request) bool {
	tokenString := r.Header.Get("Authorization")
	if len(tokenString) > 7 && tokenString[:7] == "Bearer " {
		tokenString = tokenString[7:]
	} else {
		log.Println("Invalid Authorization header format")
		return false
	}
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
