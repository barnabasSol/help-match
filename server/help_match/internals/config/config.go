package config

import "os"

func GetConf(key string) string {
	return os.Getenv(key)
}
