package handlers

import (
	"context"
	"log"
	"net/http"
	"time"

	"github.com/julienschmidt/httprouter"
	auth_errors "hm.barney-host.site/internals/features/auth/errors"
	"hm.barney-host.site/internals/features/users/service"
	"hm.barney-host.site/internals/features/utils"
)

type User struct {
	us *service.User
}

const contextTimeout = time.Second * 7

func NewUserHandler(us *service.User) *User {
	return &User{us}
}

func (u *User) GetUser(
	w http.ResponseWriter,
	r *http.Request,
	p httprouter.Params,
) {
	claims := r.Context().Value(utils.ClaimsKey).(utils.Claims)
	ctx, cancel := context.WithTimeout(r.Context(), contextTimeout)
	defer cancel()
	user, err := u.us.GetUserInfo(ctx, claims.Subject)
	if statusCode, ok := auth_errors.AuthErrors[err]; ok {
		utils.CreateResponse(w, err, nil, statusCode, "")
		return
	} else if err != nil {
		log.Println(err)
		utils.CreateResponse(w, err, nil, http.StatusInternalServerError, "")
		return
	}
	utils.CreateResponse(w, err, user, http.StatusOK, "here's the user")
}
