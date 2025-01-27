package server

import (
	"github.com/jackc/pgx/v5/pgxpool"
	auth_h "hm.barney-host.site/internals/features/auth/handler"
	auth_r "hm.barney-host.site/internals/features/auth/repository"
	auth_s "hm.barney-host.site/internals/features/auth/service"
	chat_r "hm.barney-host.site/internals/features/chat/repository"
	filehandler "hm.barney-host.site/internals/features/file_handler"
	not_r "hm.barney-host.site/internals/features/notifications/repository"

	chat_h "hm.barney-host.site/internals/features/chat/handler"
	chat_s "hm.barney-host.site/internals/features/chat/service"
	job_h "hm.barney-host.site/internals/features/job/handler"
	job_r "hm.barney-host.site/internals/features/job/repository"
	job_s "hm.barney-host.site/internals/features/job/service"
	not_h "hm.barney-host.site/internals/features/notifications/handler"
	org_h "hm.barney-host.site/internals/features/organization/handler"
	org_r "hm.barney-host.site/internals/features/organization/repository"
	org_s "hm.barney-host.site/internals/features/organization/service"
	user_r "hm.barney-host.site/internals/features/users/repository"
)

func (as *AppServer) bootstrapHandlers(pool *pgxpool.Pool) {
	//repository
	userRepo := user_r.NewUserRepository(pool)
	authRepo := auth_r.NewAuthRepository(pool)
	orgRepo := org_r.NewOrganizationRepository(pool)
	jobRepo := job_r.NewJobRepository(pool)
	chatRepo := chat_r.NewMessageRepository(pool)
	fileRepo := filehandler.NewFileHandlerRepository(pool)
	notifRepo := not_r.NewNotificationRepository(pool)
	bootstrapEventRepository(as, chatRepo)

	//services
	authService := auth_s.NewAuthService(userRepo, authRepo, orgRepo, as.wsManager)
	orgService := org_s.NewOrgService(orgRepo, jobRepo, userRepo)
	jobService := job_s.NewJobService(jobRepo, notifRepo, orgRepo)
	chatService := chat_s.NewChatService(chatRepo)

	//handlers
	as.authHandler = auth_h.NewAuthHandler(authService)
	as.jobHandler = job_h.NewJobHandler(jobService)
	as.orgHandler = org_h.NewOrgHandler(orgService)
	as.chatHandler = chat_h.NewChatHandler(chatService)
	as.noitifHandler = not_h.NewNotificationHandler(notifRepo)
	as.FileUploadHandler = filehandler.NewFileUploadHandler(fileRepo)
}

func bootstrapEventRepository(as *AppServer, chatRepo *chat_r.Message) {
	as.wsManager.EventRepository.ChatRepository = chatRepo
}
