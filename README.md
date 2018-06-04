# dpc18bot
Dutch PHP Conference 2018 Telegram Bot

## How to
Use `docker-compose` to launch the application:

```bash
$ docker-compose run --rm app sh
```

And then `mix`:

```bash
$ mix deps.get
$ mix
```

## Tutorial

### Step 0
- explore the scaffolder structure
- configure env vars
- play with iex
- install deps
- implement /help command
- test /help command

### Step 1
- implement schedule command
- implement schedule callback
- implement talk query
- implement talk command

### Step 2
- implement speakers command
- implement speakers query
- implement speaker command

### Step 3
- Implement bookmarks store
- Implement bookmarks command
- Implement attend query
- Implement attend command
- Implement unattend query
- Implement unattend command
