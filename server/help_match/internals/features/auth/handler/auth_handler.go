package handler

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
	return &Auth{
		authService: authService,
	}
}

const contextTimeout = time.Second * 7

func (ah *Auth) Login(
	w http.ResponseWriter,
	r *http.Request,
	_ httprouter.Params,
) {
	var loginDto dto.Login
	ctx, cancel := context.WithTimeout(r.Context(), contextTimeout)
	defer cancel()

	err := utils.ReadJSON(w, r, &loginDto)
	if err != nil {
		utils.CreateResponse(w, err, nil, http.StatusInternalServerError, "")
		return
	}
	tokenResult, err := ah.authService.Login(ctx, loginDto)
	if err != nil {
		if errors.Is(err, context.Canceled) {
			utils.CreateResponse(w, err, nil, http.StatusRequestTimeout, "")
			return
		}
		if errors.Is(err, context.DeadlineExceeded) {
			utils.CreateResponse(w, err, nil, http.StatusRequestTimeout, "")
			return
		}
		if errors.Is(err, user_errors.ErrRecordNotFound) {
			utils.CreateResponse(w, err, nil, http.StatusNotFound, "")
			return
		}
		if statusCode, ok := auth_errors.AuthErrors[err]; ok {
			utils.CreateResponse(w, err, nil, statusCode, "")
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
	ctx, cancel := context.WithTimeout(r.Context(), contextTimeout)
	defer cancel()

	err := utils.ReadJSON(w, r, &signupDto)
	if err != nil {
		utils.CreateResponse(w, err, nil, http.StatusBadRequest, "")
		return
	}
	signupResponse, err := ah.authService.Signup(ctx, signupDto)

	if err != nil {
		if errors.Is(err, context.Canceled) {
			utils.CreateResponse(w, err, nil, http.StatusRequestTimeout, "")
			return
		}
		if errors.Is(err, context.DeadlineExceeded) {
			utils.CreateResponse(w, err, nil, http.StatusRequestTimeout, "")
			return
		}
		if statusCode, ok := auth_errors.AuthErrors[err]; ok {
			utils.CreateResponse(w, err, nil, statusCode, "")
			return
		}
		utils.CreateResponse(w, err, nil, http.StatusInternalServerError, "")
		return
	}
	utils.CreateResponse(w, nil, signupResponse, http.StatusOK, "successfully created account")
}

func (ah *Auth) Refresh(
	w http.ResponseWriter,
	r *http.Request,
	p httprouter.Params,
) {
	ctx, cancel := context.WithTimeout(r.Context(), contextTimeout)
	defer cancel()

	var req struct {
		Username     string `json:"username"`
		RefreshToken string `json:"refresh_token"`
	}
	err := utils.ReadJSON(w, r, &req)
	if err != nil {
		utils.CreateResponse(w, err, nil, http.StatusInternalServerError, "")
		return
	}
	tokens, err := ah.authService.RenewToken(ctx, req.RefreshToken, req.Username)
	if err != nil {
		if statusCode, ok := auth_errors.AuthErrors[err]; ok {
			utils.CreateResponse(w, err, nil, statusCode, "")
			return
		}
		utils.CreateResponse(w, err, nil, http.StatusInternalServerError, "")
		return
	}

	utils.CreateResponse(w, nil, tokens, http.StatusOK, "here are ur tokens bitch")
}
