SHELL := /bin/bash

.PHONY: help docker.start docker.stop migrate migrate-down migrate-status test run web

help:
	@printf '%s\n' \
		'make docker.start     поднять контейнеры' \
		'make docker.stop      остановить контейнеры' \
		'make migrate          накатить миграции' \
		'make migrate-down     откатить последнюю миграцию' \
		'make migrate-status   текущая версия схемы' \
		'make test             go test ./...' \
		'make run              локальный сервер' \
		'make web              админка через Vite'

docker.start:
	docker compose up -d --wait

docker.stop:
	docker compose stop

migrate:
	set -a; . ./.env; set +a; go run -tags postgres github.com/golang-migrate/migrate/v4/cmd/migrate@v4.20.1 -path migrations -database "$$DATABASE_URL" up

migrate-down:
	set -a; . ./.env; set +a; go run -tags postgres github.com/golang-migrate/migrate/v4/cmd/migrate@v4.20.1 -path migrations -database "$$DATABASE_URL" down 1

migrate-status:
	set -a; . ./.env; set +a; go run -tags postgres github.com/golang-migrate/migrate/v4/cmd/migrate@v4.20.1 -path migrations -database "$$DATABASE_URL" version

test:
	go test ./...

run:
	set -a; . ./.env; set +a; go run ./cmd/server

web:
	npm --prefix web run dev
