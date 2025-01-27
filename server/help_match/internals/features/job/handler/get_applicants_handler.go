package handler

import (
	"context"
	"errors"
	"net/http"

	"github.com/julienschmidt/httprouter"
	"hm.barney-host.site/internals/features/utils"
)

func (j *Job) GetJobApplicants(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	org_id := p.ByName("org_id")
	if org_id == "" {
		utils.CreateResponse(w, errors.New("org id isn't provided"), nil, http.StatusBadRequest, "")
		return
	}
	ctx, cancel := context.WithTimeout(r.Context(), contextTimeout)
	defer cancel()
	applicants, err := j.js.GetApplicants(ctx, org_id)
	if err != nil {
		utils.CreateResponse(w, err, nil, http.StatusInternalServerError, "")
		return
	}
	utils.CreateResponse(w, nil, applicants, http.StatusOK, "")

}
