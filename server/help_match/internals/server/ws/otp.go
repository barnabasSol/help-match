package ws

import (
	"context"
	"fmt"
	"sync"
	"time"

	"github.com/google/uuid"
)

type OTP struct {
	Key     string
	Created time.Time
}

type RetentionMap struct {
	data map[string]OTP
	mu   *sync.Mutex
}

func NewRetentionMap(
	ctx context.Context,
	retPeriod time.Duration,
) *RetentionMap {
	rm := new(RetentionMap)
	rm.data = make(map[string]OTP)
	rm.mu = &sync.Mutex{}
	go rm.Retention(ctx, retPeriod)
	return rm
}

func (rm *RetentionMap) NewOTP() OTP {
	rm.mu.Lock()
	defer rm.mu.Unlock()
	o := OTP{
		Key:     uuid.NewString(),
		Created: time.Now(),
	}
	rm.data[o.Key] = o
	return o
}

func (rm *RetentionMap) VerifyOTP(otp string) bool {
	rm.mu.Lock()
	defer rm.mu.Unlock()
	if _, ok := rm.data[otp]; !ok {
		return false
	}
	delete(rm.data, otp)
	return true
}

func (rm *RetentionMap) Retention(
	ctx context.Context,
	retentionPeriod time.Duration,
) {
	ticker := time.NewTicker(400 * time.Millisecond)
	defer ticker.Stop()
	for {
		select {
		case <-ticker.C:
			rm.mu.Lock()
			for _, otp := range rm.data {
				fmt.Println(len(rm.data))
				fmt.Println(otp)
				if otp.Created.Add(retentionPeriod).Before(time.Now()) {
					delete(rm.data, otp.Key)
				}
			}
			rm.mu.Unlock()
		case <-ctx.Done():
			return
		}

	}
}
