package handler

import (
	"context"
	"net/http"
	"time"

	"github.com/julienschmidt/httprouter"
	"hm.barney-host.site/internals/features/notifications/dto"
	"hm.barney-host.site/internals/features/notifications/repository"
	"hm.barney-host.site/internals/features/utils"
)

type Notification struct {
	notifRepo repository.NotificationRepository
}

const contextTimeout = time.Second * 7

func NewNotificationHandler(notifRepo repository.NotificationRepository) *Notification {
	return &Notification{notifRepo}
}

func (n *Notification) GetOrganizationNotifications(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	var notifications []dto.OrgNotification
	ctx, cancel := context.WithTimeout(r.Context(), contextTimeout)
	claims := r.Context().Value("claims").(utils.Claims)
	defer cancel()
	err := n.notifRepo.GetOrganizationNotifications(ctx, claims.Subject, &notifications)
	if err != nil {
		utils.CreateResponse(w, err, nil, http.StatusInternalServerError, "")
	}
	utils.CreateResponse(w, nil, notifications, http.StatusOK, "")
}

func (n *Notification) GetVolunteerNotifications(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	var notifications []dto.VolunteerNotification
	ctx, cancel := context.WithTimeout(r.Context(), contextTimeout)
	claims := r.Context().Value("claims").(utils.Claims)
	defer cancel()
	err := n.notifRepo.GetVolunteerNotifications(ctx, claims.Subject, &notifications)
	if err != nil {
		utils.CreateResponse(w, err, nil, http.StatusInternalServerError, "")
	}
	utils.CreateResponse(w, nil, notifications, http.StatusOK, "")
}
