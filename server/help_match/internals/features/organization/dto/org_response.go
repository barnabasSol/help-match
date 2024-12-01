package dto

type OrgResponse struct {
	Name        string   `json:"org_name"`
	Description string   `json:"description"`
	Location    Location `json:"location"`
	Version     int      `json:"version"`
}
