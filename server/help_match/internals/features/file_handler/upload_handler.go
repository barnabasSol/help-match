package filehandler

import (
	"net/http"

	"github.com/julienschmidt/httprouter"
)

type FileUploadHandler struct {
	fr *FileHandlerRepository
}

func Upload(w http.ResponseWriter, r *http.Request, p httprouter.Params) {

}
