package user_errors

import "errors"

var (
	ErrRecordNotFound = errors.New("this user doen't exist sadly")
)
