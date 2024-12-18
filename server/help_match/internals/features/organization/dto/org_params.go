package dto

import "hm.barney-host.site/internals/features/utils"

type OrgParams struct {
	Filters utils.Filter
	OrgName string `json:"org_name"`
	Type    string `json:"type"`
}
