package main

import (
	"context"
	"log"

	"github.com/joho/godotenv"
	"hm.barney-host.site/internals/db"
	server "hm.barney-host.site/internals/server/http"
	"hm.barney-host.site/internals/server/ws"
)

func main() {
	if err := godotenv.Load(); err != nil {
		log.Println("Error loading .env file")
		return
	}
	pgPool, err := db.InitPostgres()
	if err != nil {
		log.Printf("failed to init postgres: %v", err)
		return
	}

	wsManager := ws.NewManager(context.Background())

	appServer := server.New()
	if err := appServer.Serve(pgPool, wsManager); err != nil {
		log.Printf("failed to serve: %v", err)
		return
	}

}
