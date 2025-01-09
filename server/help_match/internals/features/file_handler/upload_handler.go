package filehandler

import (
	"fmt"
	"io"
	"net/http"
	"path/filepath"

	"github.com/google/uuid"
	"github.com/julienschmidt/httprouter"
	"hm.barney-host.site/internals/features/auth/dto"
	"hm.barney-host.site/internals/features/utils"
)

type FileUploadHandler struct {
	fr FileHandlerRepository
}

func NewFileUploadHandler(fr FileHandlerRepository) *FileUploadHandler {
	return &FileUploadHandler{fr}
}

func (f *FileUploadHandler) Upload(
	w http.ResponseWriter,
	r *http.Request,
	p httprouter.Params,
) {
	q := r.URL.Query()
	uploadType := utils.ReadString(q, "type", "")
	claims := r.Context().Value(utils.ClaimsKey).(utils.Claims)
	if claims.Role == string(dto.User) && uploadType == "post" {
		http.Error(w, "Users aren't allowed to post for now", http.StatusForbidden)
		return
	}
	if !isValidUploadType(uploadType) {
		http.Error(w, "Invalid upload type", http.StatusBadRequest)
		return
	}
	err := r.ParseMultipartForm(10 << 20)
	if err != nil {
		http.Error(w, "Error parsing multipart form", http.StatusBadRequest)
		return
	}

	file, handler, err := r.FormFile("the_file")
	if err != nil {
		http.Error(w, "Error retrieving the file", http.StatusBadRequest)
		return
	}
	defer file.Close()

	fileBytes, err := io.ReadAll(file)
	if err != nil {
		http.Error(w, "Invalid file", http.StatusBadRequest)
		return
	}

	if !isValidFileType(fileBytes) {
		http.Error(w, "Invalid file type", http.StatusUnsupportedMediaType)
		return
	}

	ext := filepath.Ext(handler.Filename)

	fileName := uuid.NewString() + ext

	dst, fullPath, err := createFile(fileName, uploadType)
	fmt.Println(fullPath)
	if err != nil {
		http.Error(w, "Error saving the file", http.StatusInternalServerError)
		return
	}
	defer dst.Close()

	_, err = dst.Write(fileBytes)
	if err != nil {
		http.Error(w, "Error saving the file", http.StatusInternalServerError)
		return
	}

	if uploadType == "post" {
		err := f.fr.InsertPost(r.Context(), fullPath, claims.OrgId)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
		}
	} else if uploadType == "profile" {
		err := f.fr.UpdateProfile(r.Context(), fullPath, claims.Subject)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
		}
	}
	utils.CreateResponse(w, nil, Response{ImgUrl: fullPath}, http.StatusOK, "here's the updated image")

	// fmt.Fprintf(w, "File Name: %v\n", handler.Filename)
	// fmt.Fprintf(w, "File Size: %v\n", handler.Size)
	// fmt.Fprintf(w, "MIME Header: %v\n", handler.Header)
}
