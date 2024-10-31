package db

import (
	"context"
	"fmt"
	"os"
	"strconv"
	"time"

	"github.com/go-redis/redis/v8"
)

func InitRedis() (*redis.Client, error) {
	redisAddr := os.Getenv("REDIS_ADDRESS")
	redisPassword := os.Getenv("REDIS_PASSWORD")
	redisDB := os.Getenv("REDIS_DB")

	if redisAddr == "" {
		return nil, fmt.Errorf("Redis address is missing")
	}

	db, err := strconv.Atoi(redisDB)
	if err != nil {
		return nil, fmt.Errorf("invalid value for REDIS_DB: %w", err)
	}

	rdb := redis.NewClient(&redis.Options{
		Addr:         redisAddr,
		Password:     redisPassword,
		DB:           db,
		PoolSize:     10,
		MinIdleConns: 5,
		IdleTimeout:  30 * time.Second,
	})

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	_, err = rdb.Ping(ctx).Result()
	if err != nil {
		return nil, fmt.Errorf("unable to connect to Redis: %w", err)
	}

	return rdb, nil
}
