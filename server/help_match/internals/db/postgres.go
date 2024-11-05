package db

import (
	"context"
	"fmt"
	"strconv"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"hm.barney-host.site/internals/config"
)

func InitPostgres() (*pgxpool.Pool, error) {
	connectionString := config.GetConf("DATABASE_CONNECTION_STRING")
	maxIdleConnectionsStr := config.GetConf("DATABASE_MAX_IDLE_CONNECTIONS")
	maxOpenConnectionsStr := config.GetConf("DATABASE_MAX_OPEN_CONNECTIONS")
	connectionMaxLifetimeStr := config.GetConf("DATABASE_CONNECTION_MAX_LIFETIME")

	if connectionString == "" {
		return nil, fmt.Errorf("database connection string is missing")
	}

	maxIdleConnections, err := strconv.Atoi(maxIdleConnectionsStr)
	if err != nil {
		return nil, fmt.Errorf("invalid value for DATABASE_MAX_IDLE_CONNECTIONS: %w", err)
	}

	maxOpenConnections, err := strconv.Atoi(maxOpenConnectionsStr)
	if err != nil {
		return nil, fmt.Errorf("invalid value for DATABASE_MAX_OPEN_CONNECTIONS: %w", err)
	}

	connectionMaxLifetime, err := time.ParseDuration(connectionMaxLifetimeStr)
	if err != nil {
		return nil, fmt.Errorf("invalid value for DATABASE_CONNECTION_MAX_LIFETIME: %w", err)
	}

	poolConfig, err := pgxpool.ParseConfig(connectionString)
	if err != nil {
		return nil, fmt.Errorf("unable to parse database URL: %w", err)
	}

	poolConfig.MaxConns = int32(maxOpenConnections)
	poolConfig.MinConns = int32(maxIdleConnections)
	poolConfig.MaxConnIdleTime = connectionMaxLifetime

	dbPool, err := pgxpool.NewWithConfig(context.Background(), poolConfig)
	if err != nil {
		return nil, fmt.Errorf("unable to create connection pool: %w", err)
	}

	if err = dbPool.Ping(context.Background()); err != nil {
		dbPool.Close()
		return nil, fmt.Errorf("unable to connect to database: %w", err)
	}

	return dbPool, nil
}
