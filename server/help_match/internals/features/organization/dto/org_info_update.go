package dto

type OrgInfoUpdateDto struct {
	OrgName     *string   `json:"org_name"`
	OrgType     *string   `json:"org_type"`
	Description *string   `json:"description"`
	Location    *Location `json:"location"`
}
