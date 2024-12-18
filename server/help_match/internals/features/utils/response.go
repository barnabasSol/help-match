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
		Message string `json:"message,omitempty"`
		Data    any    `json:"data"`
	}
	w.Header().Set("Content-Type", "application/json")

	var res response
	if err != nil {
		res = response{
			Message: err.Error(),
			Data:    nil,
		}
	} else {
		res = response{
			Message: message,
			Data:    data,
		}
	}

	r, jsonErr := json.Marshal(res)
	if jsonErr != nil {
		http.Error(
			w,
			"Failed to marshal response",
			http.StatusInternalServerError,
		)
		return
	}

	w.WriteHeader(status)
	w.Write(r)
}
