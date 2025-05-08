package filehandler

import (
	"fmt"
	"net/http"
	"os"
	"path/filepath"
	"strings"
)

func createFile(filename, location string) (*os.File, string, error) {
	path := fmt.Sprintf("public/%v/", location)
	if _, err := os.Stat(path); os.IsNotExist(err) {
		os.Mkdir(path, 0755)
	}

	dst, err := os.Create(filepath.Join(path, filename))
	if err != nil {
		return nil, "", err
	}

	return dst, path + filename, nil
}

var validUploadTypes = map[string]struct{}{
	"profile": {},
	"post":    {},
}

func isValidUploadType(incommingType string) bool {
	_, found := validUploadTypes[incommingType]
	return found
}

func isValidFileType(file []byte) bool {
	fileType := http.DetectContentType(file)
	return strings.HasPrefix(fileType, "image/")
}
