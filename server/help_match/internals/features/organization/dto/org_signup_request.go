package dto

type OrgSignup struct {
	OrgName     string   `json:"org_name"`
	Password    string   `json:"password"`
	Description string   `json:"description"`
	Type        string   `json:"type"`
	Location    Location `json:"location"`
	UserId      string   `json:"user_id"`
}

type Location struct {
	Latitude  float64
	Longitude float64
}
