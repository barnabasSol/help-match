package handler

import (
	"context"
	"net/http"
	"time"

	"github.com/julienschmidt/httprouter"
	"hm.barney-host.site/internals/features/organization/service"
	"hm.barney-host.site/internals/features/utils"
)

type Organization struct {
	os *service.OrgService
}

func NewOrgHandler(os *service.OrgService) *Organization {
	return &Organization{os}
}

func (oh *Organization) GetOrganization(
	w http.ResponseWriter,
	r *http.Request,
	p httprouter.Params,
) {
	ctx, cancel := context.WithTimeout(r.Context(), 7*time.Second)
	defer cancel()
	result, err := oh.os.GetOrganization(ctx, p.ByName("id"))
	if err != nil {
		utils.CreateResponse(w, err, nil, http.StatusInternalServerError, "whoopsie")
		return
	}
	utils.CreateResponse(w, nil, *result, http.StatusOK, "there u go")
}
