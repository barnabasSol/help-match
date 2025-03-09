package dto

type OrgListResponse struct {
	Id          string    `json:"org_id"`
	Name        string    `json:"org_name"`
	ProfileIcon string    `json:"profile_icon"`
	Proximity   float64   `json:"proximity"`
	Location    *Location `json:"location,omitempty"`
	IsVerified  bool      `json:"is_verified"`
	Type        string    `json:"type"`
}
