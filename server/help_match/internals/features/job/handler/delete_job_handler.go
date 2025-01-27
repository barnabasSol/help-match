package handler

import (
	"context"
	"errors"
	"net/http"

	"github.com/julienschmidt/httprouter"
	"hm.barney-host.site/internals/features/utils"
)

func (j *Job) DeleteOrgJob(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	job_id := p.ByName("job_id")
	if job_id == "" {
		utils.CreateResponse(w, errors.New("job id isn't provided"), nil, http.StatusBadRequest, "")
		return
	}
	ctx, cancel := context.WithTimeout(r.Context(), contextTimeout)
	defer cancel()
	err := j.js.DeleteOrgJob(ctx, job_id)
	if err != nil {
		utils.CreateResponse(w, err, nil, http.StatusInternalServerError, "failed to delete job")
		return
	}
	utils.CreateResponse(w, nil, nil, http.StatusOK, "job deleted successfully")
}
