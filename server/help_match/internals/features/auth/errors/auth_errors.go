package auth_errors

import "errors"

var (
	ErrUserDoesntExist           = errors.New("user doesnt exist")
	ErrFailedTokenGen            = errors.New("failed to generate token")
	ErrTimeOut                   = errors.New("process took too long, try again")
	ErrIncorrectUsernamePassword = errors.New("invalid username or password")
	ErrInvalidRole               = errors.New("invalid role")
)
