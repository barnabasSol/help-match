package dto

import (
	auth_errors "hm.barney-host.site/internals/features/auth/errors"
	"hm.barney-host.site/internals/features/organization/dto"
)

type Signup struct {
	OrgInfo   *dto.OrgSignup    `json:"org_info,omitempty"`
	Name      string            `json:"name"`
	Username  string            `json:"username"`
	Email     string            `json:"email"`
	Password  string            `json:"password"`
	Role      AllowedRole       `json:"role"`
	Interests *AllowedInterests `json:"interests,omitempty"`
}

func (s *Signup) Validate() error {
	if s.Name == "" {
		return auth_errors.ErrNameRequired
	}
	if s.Username == "" {
		return auth_errors.ErrUsernameRequired
	}
	if s.Email == "" {
		return auth_errors.ErrEmailRequired
	}
	// if !isEmailValid(s.Email) {
	// 	return errors.New("email is in invalid format")
	// }
	if s.Password == "" {
		return auth_errors.ErrPasswordRequired
	}

	if !s.Role.IsValid() {
		return auth_errors.ErrInvalidRole
	}

	if s.Role == Organization && s.OrgInfo == nil {
		return auth_errors.ErrOrgInfoRequiredForOrgRole
	}

	if s.Role == Organization {
		if err := s.OrgInfo.Validate(); err != nil {
			return auth_errors.ErrInvalidRole
		}
	}

	if s.Role == User {
		if s.Interests == nil {
			return auth_errors.ErrEmptyInterestsTopics
		}
		if len(*s.Interests) == 0 {
			return auth_errors.ErrEmptyInterestsTopics
		}
	}

	return nil
}

type AllowedRole string

const (
	User         AllowedRole = "user"
	Organization AllowedRole = "organization"
)

type AllowedInterests []string

func (ar AllowedRole) IsValid() bool {
	return ar == User || ar == Organization
}
