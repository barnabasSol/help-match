package dto

import "errors"

type JobUpdateDto struct {
	JobID  string `json:"job_id"`
	UserId string `json:"user_id"`
	Status string `json:"status"`
}

func (j JobUpdateDto) Validate() error {
	if j.JobID == "" {
		return errors.New("job_id is required")
	}
	if j.UserId == "" {
		return errors.New("user_id is required")
	}
	if j.Status == "" {
		return errors.New("status is required")
	}
	return nil
}
