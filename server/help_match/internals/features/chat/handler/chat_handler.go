package handler

import (
	"context"
	"net/http"
	"time"

	"github.com/julienschmidt/httprouter"
	"hm.barney-host.site/internals/features/chat/service"
	"hm.barney-host.site/internals/features/utils"
)

type Chat struct {
	chatService *service.Chat
}

const contextTimeout = time.Second * 7

func NewChatHandler(cs *service.Chat) *Chat {
	return &Chat{cs}
}

func (c *Chat) GetMessages(
	w http.ResponseWriter,
	r *http.Request,
	p httprouter.Params,
) {
	room_id := p.ByName("room_id")
	data, err := c.chatService.GetMessages(r.Context(), room_id)
	if err != nil {
		utils.CreateResponse(w, err, nil, http.StatusInternalServerError, "")
		return
	}
	utils.CreateResponse(w, nil, data, http.StatusOK, "here are the messages")
}

func (c *Chat) GetRooms(
	w http.ResponseWriter,
	r *http.Request,
	p httprouter.Params,
) {
	ctx, cancel := context.WithTimeout(r.Context(), contextTimeout)
	defer cancel()
	claims := ctx.Value(utils.ClaimsKey).(utils.Claims)
	data, err := c.chatService.GetRooms(r.Context(), claims.Subject)
	if err != nil {
		utils.CreateResponse(w, err, nil, http.StatusInternalServerError, "")
		return
	}
	utils.CreateResponse(w, nil, data, http.StatusOK, "here are the rooms")
	return

}
