package dto

import (
	"errors"
	"fmt"

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
		return errors.New("name is required")
	}
	if s.Username == "" {
		return errors.New("username is required")
	}
	if s.Email == "" {
		return errors.New("email is required")
	}
	// if !isEmailValid(s.Email) {
	// 	return errors.New("email is in invalid format")
	// }
	if s.Password == "" {
		return errors.New("password is required")
	}

	if !s.Role.IsValid() {
		return fmt.Errorf("invalid role: %s", s.Role)
	}

	if s.Role == Organization && s.OrgInfo == nil {
		return errors.New("org_info is required for organization role")
	}

	if s.Role == Organization {
		if s.OrgInfo.OrgName == "" {
			return errors.New("org_name is required in org_info")
		}
	}

	if s.Role == User {
		if s.Interests != nil {
			if len(s.Interests.Topics) == 0 {
				return errors.New("interests topics cannot be empty")
			}
		}
	}

	return nil
}

type AllowedRole string

const (
	User         AllowedRole = "user"
	Organization AllowedRole = "organization"
)

type AllowedInterests struct {
	Topics []string
}

func (ar AllowedRole) IsValid() bool {
	return ar == User || ar == Organization
}

// func isEmailValid(email string) bool {
// 	emailRegex := regexp.MustCompile(`^(?:[a-z0-9!#$%&'*+/=?^_` + "`" + `{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_` + "`" + `{|}~-]+)*|\"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\]$`)
// 	return emailRegex.MatchString(email)
// }
