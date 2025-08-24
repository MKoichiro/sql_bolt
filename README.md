# SQL Playground

## Usage

### 1. Configuration for Initialization

Edit `init/init.sql` to set up any initial data you want to load, if necessary.

### 2. Start the Container

Use the following shorthand to run `docker compose up -d`:

```bash
  make up
```

### 3. Enter a psql Session in the Container

Use the following shorthand to run `docker compose exec -it db psql -U postgres`:

```bash
  make psql
```

### 4. Remove the Compose Setup

```bash
  make down
```

If you want to remove volumes and start fresh, use the following command.
This is equivalent to `docker volume rm practice-db-data`:

```bash
  make rm-v
```

### `dataset/` directory

The dataset directory is bind-mounted at `/home/postgres/dataset` inside the container.
Feel free to place any custom data (such as `*.sql` and `*.csv` files) in it.

### make commands

Run `make help` to see all available commands.
