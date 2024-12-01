package db

import (
	"context"
	"fmt"
	"strconv"
	"time"

	"github.com/go-redis/redis/v8"
	"hm.barney-host.site/internals/config"
)

func InitRedis() (*redis.Client, error) {
	redisAddr := config.GetEnv("REDIS_ADDRESS")
	redisPassword := config.GetEnv("REDIS_PASSWORD")
	redisDB := config.GetEnv("REDIS_DB")

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
		MaxRetries:   3,
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
