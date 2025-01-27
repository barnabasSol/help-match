package handler

import (
	"context"
	"errors"
	"net/http"

	"github.com/julienschmidt/httprouter"
	"hm.barney-host.site/internals/features/utils"
)

func (j *Job) Apply(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	job_id := p.ByName("job_id")
	if job_id == "" {
		utils.CreateResponse(w, errors.New("job id isnt provided"), nil, http.StatusBadRequest, "")
		return
	}
	claims := r.Context().Value("claims").(utils.Claims)
	ctx, cancel := context.WithTimeout(r.Context(), contextTimeout)
	defer cancel()
	err := j.js.ApplyJob(ctx, claims.Subject, job_id)
	if err != nil {
		utils.CreateResponse(w, err, nil, http.StatusInternalServerError, "failed to apply job")
		return
	}
	utils.CreateResponse(w, nil, nil, http.StatusOK, "job applied successfully")
}
