package service

import (
	"context"
	"time"

	"hm.barney-host.site/internals/features/chat/dto"
	"hm.barney-host.site/internals/features/chat/repository"
)

type Chat struct {
	messageRepo repository.MessageRepository
}

func NewChatService(mr repository.MessageRepository) *Chat {
	return &Chat{messageRepo: mr}
}

func (c *Chat) GetMessages(ctx context.Context, roomId string) (*[]dto.Message, error) {
	ct, cancel := context.WithTimeout(ctx, time.Second*5)
	defer cancel()
	messages, err := c.messageRepo.GetMessagesByRoomId(ct, roomId)
	if err != nil {
		return &[]dto.Message{}, err
	}
	return messages, nil
}

func (c *Chat) GetRooms(ctx context.Context, userId string) (*[]dto.Room, error) {
	ctx, cancel := context.WithTimeout(ctx, time.Second*5)
	defer cancel()
	rooms, err := c.messageRepo.GetRoomsByUserId(ctx, userId)
	if err != nil {
		return &[]dto.Room{}, err
	}
	return rooms, nil
}

func (c *Chat) GetOrgRooms(ctx context.Context, userId string) (*[]dto.Room, error) {
	ct, cancel := context.WithTimeout(ctx, time.Second*5)
	defer cancel()
	rooms, err := c.messageRepo.GetRoomsByUserId(ct, userId)
	if err != nil {
		return &[]dto.Room{}, err
	}
	return rooms, nil
}
