package dto

type OrgNotification struct {
	VolunteerId           string `json:"volunteer_id"`
	VolunteerName         string `json:"volunteer_name"`
	VolunteerUsernameName string `json:"volunteer_username"`
	OnlineStatus          bool   `json:"online_status"`
	VolunteerProfileIcon  string `json:"profile_icon"`
	Message               string `json:"message"`
}
