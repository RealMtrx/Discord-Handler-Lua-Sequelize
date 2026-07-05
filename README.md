# Discord-Handler-Lua-Sequelize

A Discord bot handler written in Lua using [Discordia](https://github.com/SinisterRectus/Discordia) and LuaSQL (replaces MongoDB).

## Features

- Slash command and prefix command support
- Event-driven architecture
- SQLite/PostgreSQL database via LuaSQL
- Cooldown system
- Webhook logging
- Anti-crash handler
- Configurable via `.env`

## Requirements

- [Luvit](https://luvit.io/) or compatible Lua environment with Discordia
- LuaSQL (`luasql.sqlite3` or `luasql.postgres`)
- LuaSocket

## Setup

1. Clone the repo
2. Copy `.env.example` to `.env` and fill in your values
3. Run `lit install SinisterRectus/discordia`
4. Run `lit install luvit/secure-env` or parse `.env` manually
5. Start: `luvit src/main.lua`

## Structure

```
src/
├── main.lua            Entry point
├── config.lua          Configuration loader
├── bot.lua             Bot client setup
├── database/init.lua   Database connection & query helper
├── models/user.lua     User model CRUD
├── handlers/           Loaders for commands, events, etc.
├── events/             Discord event listeners
├── core/               Utilities (webhooks, cooldowns, emojis)
└── commands/           Slash and prefix commands
```

## License

MIT
