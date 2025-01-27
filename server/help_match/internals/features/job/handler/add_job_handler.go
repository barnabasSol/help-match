package handler

import (
	"context"
	"net/http"

	"github.com/julienschmidt/httprouter"
	"hm.barney-host.site/internals/features/job/dto"
	"hm.barney-host.site/internals/features/utils"
)

func (jh *Job) AddJob(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	var incommingJob dto.JobAddDto
	err := utils.ReadJSON(w, r, &incommingJob)
	if err != nil {
		utils.CreateResponse(w, err, nil, http.StatusBadRequest, "")
		return
	}
	ctx, cancel := context.WithTimeout(r.Context(), contextTimeout)
	defer cancel()
	job, err := jh.js.AddNewOrgJob(ctx, incommingJob)
	if err != nil {
		utils.CreateResponse(w, err, nil, http.StatusInternalServerError, "")
		return
	}
	utils.CreateResponse(w, nil, job, http.StatusOK, "")
}
