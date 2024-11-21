package utils

import (
	"encoding/json"
	"net/http"
)

func CreateResponse(
	w http.ResponseWriter,
	err error,
	data any,
	status int,
	message string,
) {
	type response struct {
		Message string `json:"message"`
		Data    any    `json:"data"`
	}
	w.Header().Set("Content-Type", "application/json")
	if err != nil {
		res := response{
			Message: err.Error(),
			Data:    data,
		}
		r, _ := json.Marshal(res)
		w.WriteHeader(status)
		w.Write(r)
		return
	}
	res := response{
		Message: message,
		Data:    data,
	}
	r, _ := json.Marshal(res)
	w.WriteHeader(status)
	w.Write(r)
}
