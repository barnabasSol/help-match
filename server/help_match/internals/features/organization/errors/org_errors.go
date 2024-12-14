package errors

import (
	"errors"
	"net/http"
)

var (
	ErrOrgDoesntExist = errors.New("organization doesn't exist")
	ErrInvalidRole    = errors.New("invalid role")
)

var AuthErrors = map[error]int{
	ErrOrgDoesntExist: http.StatusNotFound,
	ErrInvalidRole:    http.StatusForbidden,
}
