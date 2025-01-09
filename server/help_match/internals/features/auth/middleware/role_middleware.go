package middleware

import (
	"net/http"

	"github.com/julienschmidt/httprouter"
	"hm.barney-host.site/internals/features/utils"
)

func RequireRole(role string, next httprouter.Handle) httprouter.Handle {
	return func(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
		userClaims := r.Context().Value(utils.ClaimsKey).(utils.Claims)
		if userClaims.Role != role {
			http.Error(w, "You dont meet the role required", http.StatusUnauthorized)
			return
		}
		next(w, r, ps)
	}
}
