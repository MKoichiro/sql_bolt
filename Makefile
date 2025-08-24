.PHONY: down up bash psql

up:
	docker compose up -d

bash:
	docker compose exec -it db bash

psql:
	docker compose exec -it db psql -U postgres

down:
	docker compose down

rm-i:
	docker image rm sql-practice-db

rm-v:
	docker volume rm practice-db-data

rm:
	docker volume rm practice-db-data
	docker image rm sql-practice-db

help:
	@echo "Available commands:"
	@grep -hE '^- [a-zA-Z_\.-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS=":.*?## "}; {printf "%-20s %s\n", $$1, $$2}' | \
	sort

# Mark the targets with comments for help display
- down:				## : docker compose down
- up:					## : docker compose up -d
- bash:				## : docker compose exec -it db bash
- psql:				## : docker compose exec -it db psql -U postgres
- rm-i:				## : docker image rm sql-practice-db
- rm-v:				## : docker volume rm practice-db-data
- rm:					## : docker volume rm practice-db-data && docker image rm sql-practice-db
