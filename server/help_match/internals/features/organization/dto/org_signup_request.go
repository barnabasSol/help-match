package dto

import (
	"errors"
	"strings"
)

type OrgSignup struct {
	OrgName     string   `json:"org_name"`
	Password    string   `json:"password"`
	Description string   `json:"description"`
	Type        string   `json:"type"`
	Location    Location `json:"location"`
}

type Location struct {
	Latitude  float64
	Longitude float64
}

func (o *OrgSignup) Validate() error {
	if strings.TrimSpace(o.OrgName) == "" {
		return errors.New("organization name cannot be empty")
	}

	if len(o.Password) < 8 {
		return errors.New("password must be at least 8 characters long")
	}

	if len(o.Description) > 500 {
		return errors.New("description cannot exceed 500 characters")
	}

	// Validate Type
	// validTypes := map[string]bool{
	// 	"Non-Profit":  true,
	// 	"Corporate":   true,
	// 	"Educational": true,
	// }
	// if !validTypes[o.Type] {
	// 	return fmt.Errorf("invalid type: %s. Must be one of: Non-Profit, Corporate, Educational", o.Type)
	// }

	// Validate Location
	if o.Location.Latitude < -90 || o.Location.Latitude > 90 {
		return errors.New("latitude must be between -90 and 90")
	}
	if o.Location.Longitude < -180 || o.Location.Longitude > 180 {
		return errors.New("longitude must be between -180 and 180")
	}
	return nil
}
