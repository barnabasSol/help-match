package handlers

import (
	"context"
	"encoding/json"
	"errors"
	"net/http"
	"time"

	"github.com/julienschmidt/httprouter"
	"hm.barney-host.site/internals/features/auth/dto"
	auth_errors "hm.barney-host.site/internals/features/auth/errors"
	"hm.barney-host.site/internals/features/auth/service"
	user_errors "hm.barney-host.site/internals/features/users/errors"
	"hm.barney-host.site/internals/features/utils"
)

type Auth struct {
	authService *service.Auth
}

func NewAuthHandler(authService *service.Auth) *Auth {
	return &Auth{authService}
}

func (ah *Auth) Login(
	w http.ResponseWriter,
	r *http.Request,
	_ httprouter.Params,
) {
	var loginDto dto.Login
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	err := utils.ReadJSON(w, r, &loginDto)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	tokenResult, err := ah.authService.Login(ctx, loginDto)

	if err != nil {
		if errors.Is(err, context.DeadlineExceeded) {
			http.Error(w, "request timed out", http.StatusRequestTimeout)
			return
		}
		if errors.Is(err, user_errors.ErrRecordNotFound) {
			http.Error(w, err.Error(), http.StatusNotFound)
			return
		}
		if errors.Is(err, auth_errors.ErrIncorrectUsernamePassword) {
			http.Error(w, err.Error(), http.StatusUnauthorized)
			return
		}
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	response := map[string]any{
		"auth_result": tokenResult,
	}

	w.WriteHeader(http.StatusOK)
	w.Header().Set("Content-Type", "")
	if err := json.NewEncoder(w).Encode(response); err != nil {
		http.Error(w, "could not encode response", http.StatusInternalServerError)
		return
	}
}

func (ah *Auth) SignUp(
	w http.ResponseWriter,
	r *http.Request,
	_ httprouter.Params,
) {
	var signupDto dto.Signup
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	err := utils.ReadJSON(w, r, &signupDto)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	signupResponse, err := ah.authService.Signup(ctx, signupDto)

	if err != nil {
		if errors.Is(err, context.DeadlineExceeded) {
			http.Error(w, "request timed out sadly", http.StatusRequestTimeout)
			return
		}
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	response := map[string]any{
		"message":  "user created successfully",
		"response": signupResponse,
	}

	if err := json.NewEncoder(w).Encode(response); err != nil {
		http.Error(w, "could not encode response", http.StatusInternalServerError)
		return
	}
}
