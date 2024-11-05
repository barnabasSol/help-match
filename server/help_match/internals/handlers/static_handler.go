package handlers

import (
	"log"
	"net/http"
	"os"
	"path/filepath"

	"github.com/julienschmidt/httprouter"
)

type StaticHandler struct{}

func NewStaticHandler() StaticHandler {
	return StaticHandler{}
}

func (StaticHandler) ServeStatic(
	w http.ResponseWriter,
	r *http.Request,
	ps httprouter.Params,
) {
	path := ps.ByName("filepath")
	cleanPath := filepath.Clean(path)
	fullPath := filepath.Join("public", cleanPath)
	if _, err := os.Stat(fullPath); os.IsNotExist(err) {
		http.NotFound(w, r)
		log.Printf("File not found: %s", fullPath)
		return
	}
	http.ServeFile(w, r, fullPath)
	log.Printf("Serving file: %s", fullPath)
}
