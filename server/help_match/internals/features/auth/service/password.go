package service

import (
	"errors"

	"golang.org/x/crypto/bcrypt"
	auth_errors "hm.barney-host.site/internals/features/auth/errors"
)

type password struct {
	plaintext *string
	hash      []byte
}

func (p *password) Set(plaintextPassword string) error {
	hash, err := bcrypt.GenerateFromPassword([]byte(plaintextPassword), 12)
	if err != nil {
		return err
	}
	p.plaintext = &plaintextPassword
	p.hash = hash
	return nil
}

func (p *password) Matches(plaintextPassword string) (bool, error) {
	err := bcrypt.CompareHashAndPassword(p.hash, []byte(plaintextPassword))
	if err != nil {
		switch {
		case errors.Is(err, bcrypt.ErrMismatchedHashAndPassword):
			return false, auth_errors.ErrIncorrectUsernamePassword
		default:
			return false, err
		}
	}
	return true, nil
}
