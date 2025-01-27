package handler

import (
	"time"

	"hm.barney-host.site/internals/features/job/service"
)

type Job struct {
	js *service.Job
}

const contextTimeout = time.Second * 7

func NewJobHandler(js *service.Job) *Job {
	return &Job{js}
}
