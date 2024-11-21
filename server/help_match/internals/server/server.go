package server

import (
	"context"
	"errors"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"hm.barney-host.site/internals/config"
	handlers "hm.barney-host.site/internals/features/auth/handler"
)

type AppServer struct {
	authHandler *handlers.Auth
}

func New() *AppServer {
	return &AppServer{}
}

func (as *AppServer) Serve(pgPool *pgxpool.Pool) error {
	as.bootStrapHandlers(pgPool)
	port := config.GetConf("PORT")
	shutdownError := make(chan error)
	srv := &http.Server{
		Addr:         fmt.Sprintf(":%v", port),
		Handler:      as.routes(),
		IdleTimeout:  time.Minute,
		ReadTimeout:  10 * time.Second,
		WriteTimeout: 30 * time.Second,
	}
	go func() {
		quit := make(chan os.Signal, 1)
		signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
		s := <-quit
		log.Printf("shutting down server %v", s.String())
		ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
		defer cancel()
		shutdownError <- srv.Shutdown(ctx)
	}()

	log.Printf("starting server %v", srv.Addr)

	err := srv.ListenAndServe()
	if !errors.Is(err, http.ErrServerClosed) {
		return err
	}
	err = <-shutdownError
	if err != nil {
		return err
	}
	log.Printf("stopped server gracefully %v", srv.Addr)
	return nil
}
