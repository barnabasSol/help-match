package middlewares

import (
	"log"
	"net/http"
)

func RecoverPanic(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		defer func() {
			if err := recover(); err != nil {
				w.Header().Set("Connection", "close")
				http.Error(w, "Something wrong happened", http.StatusInternalServerError)
				log.Println(err)
			}
		}()
		next.ServeHTTP(w, r)
	})
}
