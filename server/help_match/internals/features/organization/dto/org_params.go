package dto

import "hm.barney-host.site/internals/features/utils"

type OrgParams struct {
	utils.Filter
	Title string   `json:"title"`
	Type  []string `json:"type"`
}
