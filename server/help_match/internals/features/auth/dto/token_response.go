package dto

type Tokens struct {
	AccessToken  string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
	OTP          string `json:"otp,omitempty"`
}
