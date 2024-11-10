package dto

type Signup struct {
	Name           string `json:"name"`
	Username       string `json:"username"`
	ProfilePicUrl  string `json:"profile_pic_url"`
	Email          string `json:"email"`
	Password       string `json:"password"`
	IsOrganization bool   `json:"is_organization"`
}
