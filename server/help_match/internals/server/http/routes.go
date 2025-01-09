package server

import (
	"net/http"

	"github.com/julienschmidt/httprouter"
	"hm.barney-host.site/internals/features/auth/dto"
	mw "hm.barney-host.site/internals/features/auth/middleware"
)

func (as *AppServer) routes() http.Handler {
	router := httprouter.New()
	router.GET("/v1/health", healthCheck)
	router.GET("/v1/public/*filepath", mw.AuthMiddleware(newStaticHandler().ServeStatic))
	router.POST("/v1/upload", mw.AuthMiddleware(as.FileUploadHandler.Upload))
	router.GET("/v1/ws", mw.AuthMiddleware(as.wsManager.ServeWS))
	router.GET("/v1/otp", mw.AuthMiddleware(as.wsManager.RenewOTP))
	router.POST("/v1/auth/login", as.authHandler.Login)
	router.POST("/v1/auth/signup", as.authHandler.SignUp)
	router.POST("/v1/auth/renew", as.authHandler.Renew)
	router.GET("/v1/org/:id", mw.AuthMiddleware(as.orgHandler.GetOrganization))
	router.GET("/v1/org", mw.AuthMiddleware(mw.RequireRole(string(dto.User), as.orgHandler.GetOrganizations)))
	router.GET("/v1/chat/messages/:room_id", mw.AuthMiddleware(as.chatHandler.GetMessages))
	router.GET("/v1/chat/rooms/:user_id", mw.AuthMiddleware(as.chatHandler.GetRooms))
	r_cors := configCORS(router)
	return mw.RecoverPanic(mw.RateLimit(r_cors))
}
