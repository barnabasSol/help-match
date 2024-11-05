package services

import "errors"

var (
	ErrUserDoesntExist = errors.New("user doesnt exist")
	ErrFailedTokenGen  = errors.New("failed to generate access token")
)
