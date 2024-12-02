package server

import (
	"net/http"

	"github.com/julienschmidt/httprouter"
	"github.com/rs/cors"
	mw "hm.barney-host.site/internals/features/auth/middleware"
)

func (as *AppServer) routes() http.Handler {
	router := httprouter.New()
	router.GET("/v1/health", healthCheck)
	router.POST("/v1/auth/login", as.authHandler.Login)
	router.POST("/v1/auth/signup", as.authHandler.SignUp)
	router.GET("/v1/public/*filepath", mw.AuthMiddleware(newStaticHandler().ServeStatic))
	r_cors := configCORS(router)
	return mw.RecoverPanic(mw.RateLimit(r_cors))
}

func configCORS(r *httprouter.Router) http.Handler {
	c := cors.New(cors.Options{
		AllowedOrigins: []string{"*"},
		AllowedMethods: []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders: []string{
			"Accept",
			"Content-Type",
			"Content-Length",
			"Accept-Encoding",
			"Authorization",
		},
		AllowCredentials: false,
		MaxAge:           300,
	})
	return c.Handler(r)
}
