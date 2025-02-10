package main

import (
	"context"
	"log"
	"sync"

	"github.com/joho/godotenv"
	"hm.barney-host.site/internals/db"
	server "hm.barney-host.site/internals/server/http"
	"hm.barney-host.site/internals/server/ws"
)

func main() {
	if err := godotenv.Load(); err != nil {
		log.Fatal("Error loading .env file")
	}
	pgPool, err := db.InitPostgres()
	if err != nil {
		log.Fatal("error initializing db")
	}

	wg := &sync.WaitGroup{}
	wsManager := ws.NewManager(context.Background())

	appServer := server.New()
	if err := appServer.Serve(pgPool, wsManager, wg); err != nil {
		log.Fatalf("failed to serve: %v", err)
		return
	}
}
