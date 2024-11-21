package service

// import (
// 	"errors"

// 	"hm.barney-host.site/internals/features/auth/dto"
// 	"hm.barney-host.site/internals/features/utils"
// )

// func handleUserSignup(signupDto *dto.Signup) (*dto.SignupResponse, error) {
// 	v := utils.NewValidator()
// 	v.Check(signupDto.Email == "", "email", "email must not be empty")
// 	v.Check(signupDto.Name == "", "name", "email must not be empty")
// 	if signupDto.Name == "" {
// 		return nil, errors.New("name is required")
// 	}
// 	if signupDto.Username == "" {
// 		return nil, errors.New("username is required")
// 	}
// 	if signupDto.Email == "" {
// 		return nil, errors.New("email is required")
// 	}
// 	if signupDto.Password == "" {
// 		return nil, errors.New("password is required")
// 	}

// }
