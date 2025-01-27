package dto

type AddNotificationDto struct {
	FromId  string `json:"from_id"`
	ToId    string `json:"to_id"`
	Message string `json:"message"`
}
