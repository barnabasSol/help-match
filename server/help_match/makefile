APP_BINARY=help-match.exe

up:
	@echo Starting Docker images...
	docker-compose up -d
	@echo Docker images started!

up_build: build_app
	@echo Stopping docker images (if running)...
	docker-compose down
	@echo Building (when required) and starting docker images...
	docker-compose up --build -d
	@echo Docker images built and started!

down:
	@echo Stopping docker compose...
	docker-compose down
	@echo Done!

build_app:
	cd .\cmd\api\ && SET GOOS=linux&& SET GOARCH=amd64&& SET CGO_ENABLED=0&& go build -o ..\..\bin\${APP_BINARY}
	@echo Done!


# docker run -d --name my_postgres -e POSTGRES_DB="helpmatch_db" -e POSTGRES_USER="postgres" -e POSTGRES_PASSWORD="postybarnabas" -p 5432:5432 postgres:17.4
# docker run -d --name cache -p 6379:6379 redis:7.4 --requirepass barnabas