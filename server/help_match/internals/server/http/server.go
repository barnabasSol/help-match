package server

import (
	"context"
	"errors"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"sync"
	"syscall"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"hm.barney-host.site/internals/config"
	auth_h "hm.barney-host.site/internals/features/auth/handler"
	chat_h "hm.barney-host.site/internals/features/chat/handler"
	filehandler "hm.barney-host.site/internals/features/file_handler"
	job_h "hm.barney-host.site/internals/features/job/handler"
	notif_h "hm.barney-host.site/internals/features/notifications/handler"
	org_h "hm.barney-host.site/internals/features/organization/handler"
	user_h "hm.barney-host.site/internals/features/users/handler"
	"hm.barney-host.site/internals/server/ws"
)

type AppServer struct {
	authHandler       *auth_h.Auth
	orgHandler        *org_h.Organization
	jobHandler        *job_h.Job
	noitifHandler     *notif_h.Notification
	chatHandler       *chat_h.Chat
	FileUploadHandler *filehandler.FileUploadHandler
	wsManager         *ws.Manager
	userHandler       *user_h.User
}

func New() *AppServer {
	return &AppServer{}
}

func (as *AppServer) Serve(
	pgPool *pgxpool.Pool,
	ws *ws.Manager,
	wg *sync.WaitGroup,
) error {
	as.wsManager = ws
	as.bootstrapHandlers(pgPool)
	port := config.GetEnv("PORT")
	shutdownError := make(chan error)
	srv := &http.Server{
		Addr:         fmt.Sprintf(":%v", port),
		Handler:      as.routes(),
		IdleTimeout:  time.Minute,
		ReadTimeout:  10 * time.Second,
		WriteTimeout: 30 * time.Second,
	}

	go gracefulShutDown(shutdownError, srv)

	log.Printf("starting server %v", srv.Addr)

	err := srv.ListenAndServe()
	if !errors.Is(err, http.ErrServerClosed) {
		return err
	}
	err = <-shutdownError
	if err != nil {
		log.Println(err.Error())
		return errors.New("did not shutdown gracefully")
	}
	log.Printf("stopped server gracefully %v", srv.Addr)
	return nil
}

func gracefulShutDown(shutdownError chan error, srv *http.Server) {
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	s := <-quit
	log.Printf("shutting down server %v", s.String())

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	shutdownError <- srv.Shutdown(ctx)
}
