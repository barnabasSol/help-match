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
	router.POST("/v1/auth/login", as.authHandler.Login)
	router.POST("/v1/auth/signup", as.authHandler.SignUp)
	router.GET("/v1/public/*filepath", mw.AuthMiddleware(newStaticHandler().ServeStatic))
	router.GET("/v1/org/:id", mw.AuthMiddleware(as.orgHandler.GetOrganization))
	router.GET("/v1/org", mw.AuthMiddleware(mw.RequreRole(string(dto.User), as.orgHandler.GetOrganizations)))
	r_cors := configCORS(router)
	return mw.RecoverPanic(mw.RateLimit(r_cors))
}
