package main

import (
	"log"

	"github.com/joho/godotenv"
	"hm.barney-host.site/internals/db"
	"hm.barney-host.site/internals/server"
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
	appServer := server.New()
	if err := appServer.Serve(pgPool); err != nil {
		log.Printf("failed to serve: %v", err)
		return
	}
}
