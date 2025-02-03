package handler

import (
	"context"
	"net/http"

	"github.com/julienschmidt/httprouter"
	"hm.barney-host.site/internals/features/utils"
)

func (j *Job) GetJobApplicants(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	claims := r.Context().Value(utils.ClaimsKey).(utils.Claims)
	ctx, cancel := context.WithTimeout(r.Context(), contextTimeout)
	defer cancel()
	applicants, err := j.js.GetApplicants(ctx, claims.OrgId)
	if err != nil {
		utils.CreateResponse(w, err, nil, http.StatusInternalServerError, "")
		return
	}
	utils.CreateResponse(w, nil, applicants, http.StatusOK, "")

}
