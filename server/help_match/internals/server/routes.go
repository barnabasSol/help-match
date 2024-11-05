package server

import (
	"net/http"

	"github.com/julienschmidt/httprouter"
	"hm.barney-host.site/internals/middlewares"
)

func (as *AppServer) routes() http.Handler {
	router := httprouter.New()
	router.GET("/v1/public/*filepath", as.staticHandler.ServeStatic)
	router.GET("/v1/auth/login", as.authHandler.Login)
	router.POST("/v1/auth/signup", as.authHandler.SignUp)
	// router.NotFound = http.HandlerFunc(nil)
	// router.MethodNotAllowed = http.HandlerFunc(app.methodNotAllowedResponse)
	// router.HandlerFunc(http.MethodGet, "/v1/healthcheck", app.healthcheckHandler)
	// router.HandlerFunc(http.MethodGet, "/v1/movies", app.listMoviesHandler)
	// router.HandlerFunc(http.MethodPost, "/v1/movies", app.createMovieHandler)
	// router.HandlerFunc(http.MethodGet, "/v1/movies/:id", app.showMovieHandler)
	// router.HandlerFunc(http.MethodPatch, "/v1/movies/:id", app.updateMovieHandler)
	// router.HandlerFunc(http.MethodDelete, "/v1/movies/:id", app.deleteMovieHandler)
	// router.HandlerFunc(http.MethodPost, "/v1/users", app.registerUserHandler)
	return middlewares.RecoverPanic(router)
}
