package handlers

import (
	"context"
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
		utils.CreateResponse(w, err, nil, http.StatusInternalServerError, "")
		return
	}
	tokenResult, err := ah.authService.Login(ctx, loginDto)
	if err != nil {
		if errors.Is(err, context.DeadlineExceeded) {
			utils.CreateResponse(w, err, nil, http.StatusRequestTimeout, "")
			return
		}
		if errors.Is(err, user_errors.ErrRecordNotFound) {
			utils.CreateResponse(w, err, nil, http.StatusNotFound, "")
			return
		}
		if errors.Is(err, auth_errors.ErrIncorrectUsernamePassword) {
			utils.CreateResponse(w, err, nil, http.StatusUnauthorized, "")
			return
		}
		if errors.Is(err, auth_errors.ErrInvalidRole) {
			utils.CreateResponse(w, err, nil, http.StatusBadRequest, "")
			return
		}
		utils.CreateResponse(w, err, nil, http.StatusInternalServerError, "")
		return
	}
	utils.CreateResponse(w, nil, tokenResult, http.StatusOK, "successfuly logged in")
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
		utils.CreateResponse(w, err, nil, http.StatusInternalServerError, "")
		return
	}
	signupResponse, err := ah.authService.Signup(ctx, signupDto)

	if err != nil {
		if errors.Is(err, context.DeadlineExceeded) {
			utils.CreateResponse(w, err, nil, http.StatusRequestTimeout, "")
			return
		}
		if errors.Is(err, context.Canceled) {
			utils.CreateResponse(w, err, nil, http.StatusGone, "")
			return
		}
		utils.CreateResponse(w, err, nil, http.StatusInternalServerError, "")
		return
	}
	utils.CreateResponse(w, nil, signupResponse, http.StatusOK, "successfully created account")
}
