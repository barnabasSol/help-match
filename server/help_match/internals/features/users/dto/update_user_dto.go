package dto

type UpdateUserInfo struct {
	Name      *string          `json:"name,omitempty"`
	Username  *string          `json:"username,omitempty"`
	Email     *string          `json:"email,omitempty"`
	Interests *InterestsUpdate `json:"interests_update"`
}

type InterestsUpdate struct {
	Add    []string `json:"add"`
	Remove []string `json:"remove"`
}
