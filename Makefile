SHELL := /bin/bash

.PHONY: help db db-down db-logs migrate migrate-down migrate-status test run web

help:
	@printf '%s\n' \
		'make db              поднять Postgres' \
		'make db-down         остановить Postgres' \
		'make db-logs         логи Postgres' \
		'make migrate         накатить миграции' \
		'make migrate-down    откатить последнюю миграцию' \
		'make migrate-status  какие миграции применены' \
		'make test            go test ./...' \
		'make run             локальный сервер' \
		'make web             админка через Vite'

db:
	docker compose up -d --wait postgres

db-down:
	docker compose stop postgres

db-logs:
	docker compose logs -f postgres

migrate:
	set -a; . ./.env; set +a; goose -dir migrations postgres "$$DATABASE_URL" up

migrate-down:
	set -a; . ./.env; set +a; goose -dir migrations postgres "$$DATABASE_URL" down

migrate-status:
	set -a; . ./.env; set +a; goose -dir migrations postgres "$$DATABASE_URL" status

test:
	go test ./...

run:
	set -a; . ./.env; set +a; go run ./cmd/server

web:
	npm --prefix web run dev
