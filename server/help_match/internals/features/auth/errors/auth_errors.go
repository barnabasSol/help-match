package auth_errors

import (
	"errors"
	"net/http"
)

var (
	ErrUserDoesntExist           = errors.New("user doesnt exist")
	ErrFailedTokenGen            = errors.New("failed to generate token")
	ErrTimeOut                   = errors.New("process took too long, try again")
	ErrIncorrectUsernamePassword = errors.New("invalid username or password")
	ErrInvalidRole               = errors.New("invalid role")
	ErrNotRequiredInput          = errors.New("unrequired extra input")
	ErrNameRequired              = errors.New("name is required")
	ErrUsernameRequired          = errors.New("username is required")
	ErrEmailRequired             = errors.New("email is required")
	ErrPasswordRequired          = errors.New("password is required")
	ErrOrgInfoRequiredForOrgRole = errors.New("org_info is required for organization role")
	ErrOrgNameRequiredInOrgInfo  = errors.New("org_name is required in org_info")
	ErrEmptyInterestsTopics      = errors.New("volunteer interests cannot be empty")
)

var AuthErrors = map[error]int{
	ErrUserDoesntExist:           http.StatusNotFound,
	ErrFailedTokenGen:            http.StatusInternalServerError,
	ErrTimeOut:                   http.StatusRequestTimeout,
	ErrIncorrectUsernamePassword: http.StatusUnauthorized,
	ErrInvalidRole:               http.StatusForbidden,
	ErrNotRequiredInput:          http.StatusBadRequest,
	ErrNameRequired:              http.StatusBadRequest,
	ErrUsernameRequired:          http.StatusBadRequest,
	ErrEmailRequired:             http.StatusBadRequest,
	ErrPasswordRequired:          http.StatusBadRequest,
	ErrOrgInfoRequiredForOrgRole: http.StatusBadRequest,
	ErrOrgNameRequiredInOrgInfo:  http.StatusBadRequest,
	ErrEmptyInterestsTopics:      http.StatusBadRequest,
}
