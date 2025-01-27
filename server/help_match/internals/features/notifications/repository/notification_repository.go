package repository

import (
	"context"

	"github.com/jackc/pgx/v5/pgxpool"
	"hm.barney-host.site/internals/features/notifications/dto"
)

type NotificationRepository interface {
	AddNotification(ctx context.Context, notif dto.AddNotificationDto) error
	GetVolunteerNotifications(ctx context.Context, userId string, notifications *[]dto.VolunteerNotification) error
	GetOrganizationNotifications(ctx context.Context, userId string, notifications *[]dto.OrgNotification) error
}

type Notification struct {
	pool *pgxpool.Pool
}

func NewNotificationRepository(pool *pgxpool.Pool) *Notification {
	return &Notification{pool}
}

func (n *Notification) AddNotification(ctx context.Context, notif dto.AddNotificationDto) error {
	cmd := `INSERT INTO notifications (from_id, to_id, message) VALUES ($1, $2, $3)`
	_, err := n.pool.Exec(ctx, cmd, notif.FromId, notif.ToId, notif.Message)
	return err
}

func (n *Notification) GetVolunteerNotifications(
	ctx context.Context,
	userId string,
	notifications *[]dto.VolunteerNotification,
) error {
	query := `SELECT o.id, o.profile_icon, o.organization_name,
			  o.is_verified, o.org_type, message FROM notifications
			  JOIN organizations o ON o.user_id = notifications.from_id
			  WHERE to_id = $1`
	rows, err := n.pool.Query(ctx, query, userId)
	if err != nil {
		return err
	}
	defer rows.Close()
	for rows.Next() {
		var notif dto.VolunteerNotification
		err := rows.Scan(
			&notif.OrgId,
			&notif.ProfileIcon,
			&notif.OrgName,
			&notif.IsVerified,
			&notif.OrgType,
			&notif.Message,
		)
		if err != nil {
			return err
		}
		*notifications = append(*notifications, notif)
	}
	if *notifications == nil {
		*notifications = []dto.VolunteerNotification{}
	}
	return nil
}

func (n *Notification) GetOrganizationNotifications(
	ctx context.Context,
	userId string,
	notifications *[]dto.OrgNotification,
) error {
	query := `SELECT u.id, u.profile_icon, u.name, u.username,
			  u.is_online, message FROM notifications
			  JOIN users u ON u.id = notifications.from_id
			  WHERE to_id = $1`
	rows, err := n.pool.Query(ctx, query, userId)
	if err != nil {
		return err
	}
	defer rows.Close()
	for rows.Next() {
		var notif dto.OrgNotification
		err := rows.Scan(
			&notif.VolunteerId,
			&notif.VolunteerProfileIcon,
			&notif.VolunteerName,
			&notif.VolunteerUsernameName,
			&notif.OnlineStatus,
			&notif.Message,
		)
		if err != nil {
			return err
		}
		*notifications = append(*notifications, notif)
	}
	if *notifications == nil {
		*notifications = []dto.OrgNotification{}
	}

	return nil
}
