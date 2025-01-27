package dto

type VolunteerNotification struct {
	OrgId       string `json:"org_id"`
	ProfileIcon string `json:"org_profile_icon"`
	OrgType     string `json:"org_type"`
	OrgName     string `json:"org_name"`
	Message     string `json:"message"`
	IsVerified  bool   `json:"is_verified"`
}
