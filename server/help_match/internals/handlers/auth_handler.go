package handlers

import (
	"context"
	"errors"
	"net/http"
	"time"

	"github.com/julienschmidt/httprouter"
	services "hm.barney-host.site/internals/services/auth"
	"hm.barney-host.site/pkg/dtos"
)

type Auth struct {
	authService *services.Auth
}

func NewAuthHandler(authService *services.Auth) *Auth {
	return &Auth{authService}
}

func (ah *Auth) Login(
	w http.ResponseWriter,
	r *http.Request,
	_ httprouter.Params,
) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()
	var loginDto dtos.Login
	err := readJSON(w, r, loginDto)
	if err != nil {
		createErrorResponse(err.Error(), http.StatusBadRequest)
	}
	tokenResult, err := ah.authService.Login(ctx, loginDto)
	if err != nil {
		if errors.Is(err, context.DeadlineExceeded) {
			http.Error(w, createErrorResponse(
				"request timed out",
				http.StatusRequestTimeout,
			), http.StatusRequestTimeout)
			return
		}
		http.Error(w, createErrorResponse(
			"some internal server error occured",
			http.StatusInternalServerError,
		), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	w.Write([]byte(createSuccessResponse("auth_result", tokenResult)))
}

func (ah *Auth) SignUp(
	w http.ResponseWriter,
	r *http.Request,
	_ httprouter.Params,
) {
	var signupDto dtos.Signup
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	err := readJSON(w, r, &signupDto)
	if err != nil {
		http.Error(w, createErrorResponse(
			"Invalid request payload",
			http.StatusBadRequest,
		), http.StatusBadRequest)
		return
	}
	userModel, err := ah.authService.Signup(ctx, signupDto)
	if err != nil {
		if errors.Is(err, context.DeadlineExceeded) {
			http.Error(w, createErrorResponse(
				"request timed out sadly",
				http.StatusRequestTimeout,
			), http.StatusRequestTimeout)
			return
		}
		http.Error(
			w,
			createErrorResponse(err.Error(), http.StatusInternalServerError),
			http.StatusInternalServerError,
		)
		return
	}
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(createSuccessResponse("user", userModel)))
}
