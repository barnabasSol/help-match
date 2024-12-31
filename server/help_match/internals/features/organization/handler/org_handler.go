package handler

import (
	"context"
	"errors"
	"net/http"
	"time"

	"github.com/julienschmidt/httprouter"
	"hm.barney-host.site/internals/features/organization/dto"
	"hm.barney-host.site/internals/features/organization/service"
	"hm.barney-host.site/internals/features/utils"
)

const timeout = 7 * time.Second

type Organization struct {
	os *service.Organization
}

func NewOrgHandler(os *service.Organization) *Organization {
	return &Organization{os}
}

func (oh *Organization) GetOrganization(
	w http.ResponseWriter,
	r *http.Request,
	p httprouter.Params,
) {
	ctx, cancel := context.WithTimeout(r.Context(), timeout)
	defer cancel()
	result, err := oh.os.GetOrganization(ctx, p.ByName("id"))
	if err != nil {
		utils.CreateResponse(w, err, nil, http.StatusInternalServerError, "whoopsie")
		return
	}
	utils.CreateResponse(w, nil, *result, http.StatusOK, "there u go")
}

func (oh *Organization) GetOrganizations(
	w http.ResponseWriter,
	r *http.Request,
	_ httprouter.Params,
) {
	var userLocation dto.Location
	err := utils.ReadJSON(w, r, &userLocation)
	if err != nil {
		utils.CreateResponse(w, err, nil, http.StatusBadRequest, "")
		return
	}
	ctx, cancel := context.WithTimeout(r.Context(), timeout)
	defer cancel()
	q := r.URL.Query()
	var queryParams dto.OrgParams
	queryParams.OrgName = utils.ReadString(q, "org_name", "")
	queryParams.Type = utils.ReadString(q, "org_type", "")
	queryParams.Filters.PageSize = utils.ReadInt(q, "page_size", 20)
	queryParams.Filters.Page = utils.ReadInt(q, "page", 1)
	queryParams.Filters.Sort = utils.ReadString(q, "sort", "organization_name")
	queryParams.Filters.SortSafeList = []string{
		"organization_name",
		"org_type",
		"-organization_name",
		"-org_type",
	}
	v := utils.NewValidator()
	queryParams.Filters.Validate(v)
	if len(v.Errors) > 0 {
		utils.CreateResponse(w, errors.New("some bad query params you're giving me"), nil, http.StatusBadRequest, "")
		return
	}
	claims := r.Context().Value("claimsKey").(utils.Claims)

	type response struct {
		Result   []*dto.OrgListResponse `json:"result"`
		Metadata utils.Metadata         `json:"metadata"`
	}
	if queryParams.Type == "recommended" {
		result, metadata, err := oh.os.GetRecommendedOrgs(ctx, claims.Subject, userLocation, queryParams)
		if err != nil {
			utils.CreateResponse(w, err, nil, http.StatusInternalServerError, "")
			return
		}
		utils.CreateResponse(w, err, response{Result: result, Metadata: metadata}, http.StatusOK, "")
		return
	}

	result, metadata, err := oh.os.GetOrganizations(ctx, queryParams, claims.Subject, userLocation)
	if err != nil {
		utils.CreateResponse(w, err, nil, http.StatusInternalServerError, "")
		return
	}
	utils.CreateResponse(w, err, response{Result: result, Metadata: metadata}, http.StatusOK, "")
}
