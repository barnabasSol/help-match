package server

import (
	"net/http"

	"github.com/julienschmidt/httprouter"
	mw "hm.barney-host.site/internals/features/auth/middleware"
)

func (as *AppServer) routes() http.Handler {
	router := httprouter.New()
	router.POST("/v1/auth/login", as.authHandler.Login)
	router.POST("/v1/auth/signup/", as.authHandler.SignUp)
	router.GET("/v1/public/*filepath", mw.AuthMiddleware(newStaticHandler().ServeStatic))
	return mw.RecoverPanic(mw.RateLimit(router))
}
