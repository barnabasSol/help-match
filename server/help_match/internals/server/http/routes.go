package server

import (
	"net/http"

	"github.com/julienschmidt/httprouter"
	"hm.barney-host.site/internals/features/auth/dto"
	mw "hm.barney-host.site/internals/features/auth/middleware"
)

func (as *AppServer) routes() http.Handler {
	router := httprouter.New()
	//health check
	router.GET("/v1/health", healthCheck)
	//file handler
	router.GET("/v1/public/*filepath", mw.AuthMiddleware(newStaticHandler().ServeStatic))
	router.PATCH("/v1/upload", mw.AuthMiddleware(as.FileUploadHandler.Upload))
	//websocket
	router.GET("/v1/ws", mw.AuthMiddleware(as.wsManager.ServeWS))
	router.GET("/v1/otp", mw.AuthMiddleware(as.wsManager.RenewOTP))
	//auth
	router.POST("/v1/auth/login", as.authHandler.Login)
	router.POST("/v1/auth/signup", as.authHandler.SignUp)
	router.POST("/v1/auth/refresh", as.authHandler.Refresh)
	//user
	router.GET("/v1/user", mw.AuthMiddleware(as.userHandler.GetUser))
	router.GET("/v1/user-by/", mw.AuthMiddleware(as.userHandler.GetByUsernameOrId))
	//organization
	router.GET("/v1/org/:id", mw.AuthMiddleware(as.orgHandler.GetOrganization))
	router.POST("/v1/org", mw.AuthMiddleware(mw.RequireRole(string(dto.User), as.orgHandler.GetOrganizations)))
	//jobs
	router.GET("/v1/job/applicants", mw.AuthMiddleware(mw.RequireRole(
		string(dto.Organization),
		as.jobHandler.GetJobApplicants,
	)))
	router.DELETE("/v1/job/:job_id", mw.AuthMiddleware(mw.RequireRole(
		string(dto.Organization),
		as.jobHandler.DeleteOrgJob,
	)))
	router.POST("/v1/job/add", mw.AuthMiddleware(mw.RequireRole(
		string(dto.Organization),
		as.jobHandler.AddJob,
	)))
	router.POST("/v1/job/apply/:job_id", mw.AuthMiddleware(mw.RequireRole(
		string(dto.User),
		as.jobHandler.Apply,
	)))
	router.PATCH("/v1/job/status", mw.AuthMiddleware(mw.RequireRole(
		string(dto.Organization),
		as.jobHandler.UpdateJobStatusOfApplicant,
	)))
	//notification
	router.GET("/v1/notifications/volunteer", mw.AuthMiddleware(mw.RequireRole(
		string(dto.User),
		as.noitifHandler.GetVolunteerNotifications,
	)))
	router.GET("/v1/notifications/organization", mw.AuthMiddleware(mw.RequireRole(
		string(dto.Organization),
		as.noitifHandler.GetOrganizationNotifications,
	)))
	//chat
	router.GET("/v1/chat/messages/:room_id", mw.AuthMiddleware(as.chatHandler.GetMessages))
	router.GET("/v1/chat/rooms", mw.AuthMiddleware(as.chatHandler.GetRooms))
	r_cors := configCORS(router)
	return mw.RecoverPanic(mw.RateLimit(r_cors))
}
