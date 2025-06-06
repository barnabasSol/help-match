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
	godotenv.Load()
	pgPool, err := db.InitPostgres()
	if err != nil {
		log.Fatal("error initializing db", err)
	}

	log.Println("connected to postgres")

	redisClient, err := db.InitRedis()

	if err != nil {
		log.Fatal("error initializing redis", err)
	}

	log.Println("connected to redis")

	wg := &sync.WaitGroup{}
	wsManager := ws.NewManager(context.Background(), wg)

	appServer := server.New()
	if err := appServer.Serve(pgPool, redisClient, wsManager, wg); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
