package server

import (
	"net/http"

	"github.com/julienschmidt/httprouter"
)

func healthCheck(
	w http.ResponseWriter,
	r *http.Request,
	_ httprouter.Params,
) {
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("I'm OK"))
}
