package handler

import (
	"context"
	"net/http"

	"github.com/julienschmidt/httprouter"
	"hm.barney-host.site/internals/features/job/dto"
	"hm.barney-host.site/internals/features/utils"
)

func (j *Job) UpdateJobStatusOfApplicant(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	var req dto.JobUpdateDto
	err := utils.ReadJSON(w, r, &req)
	if err != nil {
		utils.CreateResponse(w, err, nil, http.StatusBadRequest, "")
		return
	}
	ctx, cancel := context.WithTimeout(r.Context(), contextTimeout)
	defer cancel()
	claims := r.Context().Value(utils.ClaimsKey).(utils.Claims)
	err = j.js.UpdateJobStatus(ctx, req, claims.Subject)
	if err != nil {
		utils.CreateResponse(w, err, nil, http.StatusInternalServerError, "")
		return
	}
	utils.CreateResponse(w, nil, nil, http.StatusOK, "")
}
