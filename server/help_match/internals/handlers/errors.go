package handlers

import "encoding/json"

func createErrorResponse(message string, statusCode int) string {
	response := map[string]any{
		"error":       message,
		"status_code": statusCode,
	}
	json.Marshal(generic[int]{Status: "asd", Data: 2})
	jsonResponse, _ := json.Marshal(response)
	return string(jsonResponse)
}

type generic[T any] struct {
	Status string
	Data   T
}

func createResponse[T string](message T, statusCode int) string {
	response := map[string]any{
		"error":       message,
		"status_code": statusCode,
	}
	jsonResponse, _ := json.Marshal(response)
	return string(jsonResponse)
}
