<div align="center">
  <h1>Discord Handler — Lua (SQL Edition)</h1>
  <p><strong>A production-ready Discord bot framework built with Discordia and LuaSQL — supports SQLite, PostgreSQL, and MySQL with a modular src/ architecture.</strong></p>

  <p>
    <a href="https://github.com/RealMtrx/Discord-Handler-Lua-Sequelize/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License"></a>
    <a href="https://github.com/RealMtrx/Discord-Handler-Lua-Sequelize/releases"><img src="https://img.shields.io/badge/version-0.9.0--beta-yellow" alt="Version 0.9.0 Beta"></a>
    <a href="https://github.com/RealMtrx/Discord-Handler-Lua-Sequelize/stargazers"><img src="https://img.shields.io/github/stars/RealMtrx/Discord-Handler-Lua-Sequelize" alt="Stars"></a>
    <a href="https://github.com/RealMtrx/Discord-Handler-Lua-Sequelize/issues"><img src="https://img.shields.io/github/issues/RealMtrx/Discord-Handler-Lua-Sequelize" alt="Issues"></a>
    <a href="https://github.com/RealMtrx/Discord-Handler-Lua-Sequelize/network"><img src="https://img.shields.io/github/forks/RealMtrx/Discord-Handler-Lua-Sequelize" alt="Forks"></a>
    <a href="https://github.com/RealMtrx/Discord-Handler/graphs/contributors"><img src="https://img.shields.io/badge/ecosystem-26%20repos-brightgreen" alt="26 Repos"></a>
    <a href="https://discord.gg/0hu2"><img src="https://img.shields.io/badge/discord-0hu2-5865F2" alt="Discord"></a>
  </p>

  <br>

  <p>
    <a href="#-features">Features</a> •
    <a href="#-quick-start">Quick Start</a> •
    <a href="#-project-structure">Structure</a> •
    <a href="#-database-configuration">Database Config</a> •
    <a href="#-api-reference">API</a> •
    <a href="#-mongodb-edition">MongoDB Edition</a> •
    <a href="#-related-repositories">Ecosystem</a>
  </p>
</div>

---

## Overview

An SQL edition of the Discord Handler framework built with **Lua**, **Discordia** (Discord library), and **LuaSQL** (SQLite / PostgreSQL / MySQL database driver). It mirrors the architecture of the MongoDB edition, replacing document storage with relational database support while keeping the same modular structure, anti-crash protection, webhook logging, and dual command system.

## Features

- **Dual Command System** — Slash commands and prefix commands
- **Event-Driven Architecture** — Fully event-driven via Discordia
- **LuaSQL Integration** — Supports SQLite3, PostgreSQL, and MySQL drivers
- **Anti-Crash Handler** — Global error catching that keeps your bot online
- **Webhook Error Logging** — Real-time error and guild event reporting
- **Cooldown System** — Per-command rate limiting
- **Emoji Constants** — Centralized unicode emoji definitions
- **Environment Configuration** — Secure token management via `.env`

## Quick Start

```bash
# Clone
git clone https://github.com/RealMtrx/Discord-Handler-Lua-Sequelize.git
cd Discord-Handler-Lua-Sequelize

# Configure
cp .env.example .env
# Edit .env with your bot token and database settings

# Install Lua dependencies (Luvit environment)
lit install SinisterRectus/discordia
lit install luvit/secure-env

# Or using LuaRocks
luarocks install discordia
luarocks install luasql-sqlite3
luarocks install luasocket
luarocks install dkjson

# Run the bot
luvit src/main.lua
```

## Project Structure

```
src/
├── main.lua                       # Entry point
├── bot.lua                        # Bot client setup
├── config.lua                     # .env configuration loader
├── database/
│   └── init.lua                   # LuaSQL connection & query helper
├── models/
│   └── user.lua                   # User model CRUD
├── handlers/
│   ├── anticrash.lua              # Global error handler
│   ├── commands.lua               # Slash command loader
│   ├── events.lua                 # Event loader
│   ├── logger.lua                 # Logging utility
│   └── prefix.lua                 # Prefix command handler
├── events/
│   ├── ready.lua                  # Bot ready event
│   ├── message_create.lua         # Message create listener
│   ├── interaction_create.lua     # Interaction create listener
│   ├── guild_create.lua           # Guild create listener
│   └── guild_delete.lua           # Guild delete listener
├── core/
│   ├── webhooks.lua               # Webhook sender
│   ├── emojis.lua                 # Emoji constants
│   ├── command_utils.lua          # Command helpers
│   └── cooldown.lua               # Cooldown manager
└── commands/
    ├── slash/public/ping.lua      # Example slash command
    └── prefix/public/ping.lua     # Example prefix command
```

## Database Configuration

Configure your database in `.env`:

```env
# Bot
BOT_TOKEN=your_discord_bot_token_here
CLIENT_ID=your_application_id_here
GUILD_ID=optional_dev_guild_id
PREFIX=!
OWNER_ID=your_discord_user_id

# Database
DB_DIALECT=sqlite3        # sqlite3 | postgresql | mysql
DB_HOST=localhost
DB_PORT=5432
DB_NAME=discord_bot
DB_USER=postgres
DB_PASS=your_db_password

# Webhooks
WEBHOOK_LOG_URL=
WEBHOOK_ERROR_URL=
WEBHOOK_STATUS_URL=
```

### Dialect examples

**SQLite3 (default)** — zero configuration, file-based:
```env
DB_DIALECT=sqlite3
```

**PostgreSQL**:
```env
DB_DIALECT=postgresql
DB_HOST=localhost
DB_PORT=5432
DB_NAME=discord_bot
DB_USER=postgres
DB_PASS=your_password
```

**MySQL**:
```env
DB_DIALECT=mysql
DB_HOST=localhost
DB_PORT=3306
DB_NAME=discord_bot
DB_USER=root
DB_PASS=your_password
```

## API Reference

### LuaSQL Database Setup (`src/database/init.lua`)

```lua
local luasql = require('luasql.' .. (config.DB_DIALECT or 'sqlite3'))

local db = nil

function Database.connect()
  local dialect = config.DB_DIALECT or 'sqlite3'
  local env = luasql[ dialect ]()

  if dialect == 'sqlite3' then
    db = env:connect('database.sqlite')
  else
    db = env:connect(
      config.DB_NAME or 'discord_bot',
      config.DB_USER or 'root',
      config.DB_PASS or '',
      config.DB_HOST or 'localhost',
      config.DB_PORT or 3306
    )
  end

  db:execute([[
    CREATE TABLE IF NOT EXISTS users (
      id TEXT PRIMARY KEY,
      username TEXT,
      discriminator TEXT,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  ]])

  return db
end

function Database.query(sql, ...)
  return db:execute(sql)
end

function Database.close()
  if db then db:close() end
end

return Database
```

### Slash Command Example (`src/commands/slash/public/ping.lua`)

```lua
local SlashPing = {}

SlashPing.name = 'ping'
SlashPing.description = 'Replies with Pong!'

function SlashPing.execute(interaction)
  interaction:reply({ content = 'Pong!' })
end

return SlashPing
```

### Prefix Command Example (`src/commands/prefix/public/ping.lua`)

```lua
local PrefixPing = {}

PrefixPing.name = 'ping'

function PrefixPing.execute(message)
  message:reply('Pong!')
end

return PrefixPing
```

## Adding Commands

1. Create a file in `src/commands/slash/public/<name>.lua` or `src/commands/prefix/public/<name>.lua`
2. Return a table with `name`, `description` (slash only), and an `execute` function
3. The command loader automatically picks up new files

## MongoDB Edition

Prefer a document database? Use the **MongoDB edition** of this handler:

<div align="center">
  <a href="https://github.com/RealMtrx/Discord-Handler-Lua"><img src="https://img.shields.io/badge/Discord--Handler--Lua-MongoDB%20Edition-blue?style=for-the-badge" alt="MongoDB Edition"></a>
</div>

The MongoDB edition uses LuaMongo instead of LuaSQL, but shares the same command, event, and handler structure. You can switch between editions without relearning the architecture.

## Related Repositories

The Discord Handler ecosystem includes **26 repositories** — 13 Core Framework (MongoDB) editions and 13 Database (SQL) editions, covering 13 programming languages.

### Core Framework (MongoDB) Editions

| # | Language | Repository |
|---|----------|------------|
| 1 | JavaScript | [Discord-Handler-Js](https://github.com/RealMtrx/Discord-Handler-Js) |
| 2 | TypeScript | [Discord-Handler-Ts](https://github.com/RealMtrx/Discord-Handler-Ts) |
| 3 | Go | [Discord-Handler-Go](https://github.com/RealMtrx/Discord-Handler-Go) |
| 4 | Rust | [Discord-Handler-Rs](https://github.com/RealMtrx/Discord-Handler-Rs) |
| 5 | Python | [Discord-Handler-Py](https://github.com/RealMtrx/Discord-Handler-Py) |
| 6 | C# | [Discord-Handler-Cs](https://github.com/RealMtrx/Discord-Handler-Cs) |
| 7 | Java | [Discord-Handler-Java](https://github.com/RealMtrx/Discord-Handler-Java) |
| 8 | Kotlin | [Discord-Handler-Kt](https://github.com/RealMtrx/Discord-Handler-Kt) |
| 9 | C++ | [Discord-Handler-Cpp](https://github.com/RealMtrx/Discord-Handler-Cpp) |
| 10 | Dart | [Discord-Handler-Dart](https://github.com/RealMtrx/Discord-Handler-Dart) |
| 11 | Ruby | [Discord-Handler-Rb](https://github.com/RealMtrx/Discord-Handler-Rb) |
| 12 | **Lua** | [Discord-Handler-Lua](https://github.com/RealMtrx/Discord-Handler-Lua) |
| 13 | PHP | [Discord-Handler-Php](https://github.com/RealMtrx/Discord-Handler-Php) |

### Database (SQL) Editions

| # | Language | Repository | ORM |
|---|----------|------------|-----|
| 1 | JavaScript | [Discord-Handler-Js-Sequelize](https://github.com/RealMtrx/Discord-Handler-Js-Sequelize) | Sequelize |
| 2 | TypeScript | [Discord-Handler-Ts-Sequelize](https://github.com/RealMtrx/Discord-Handler-Ts-Sequelize) | Sequelize |
| 3 | Go | [Discord-Handler-Go-Sequelize](https://github.com/RealMtrx/Discord-Handler-Go-Sequelize) | GORM |
| 4 | Rust | [Discord-Handler-Rs-Sequelize](https://github.com/RealMtrx/Discord-Handler-Rs-Sequelize) | Diesel |
| 5 | Python | [Discord-Handler-Py-Sequelize](https://github.com/RealMtrx/Discord-Handler-Py-Sequelize) | SQLAlchemy |
| 6 | C# | [Discord-Handler-Cs-Sequelize](https://github.com/RealMtrx/Discord-Handler-Cs-Sequelize) | EF Core |
| 7 | Java | [Discord-Handler-Java-Sequelize](https://github.com/RealMtrx/Discord-Handler-Java-Sequelize) | Hibernate |
| 8 | Kotlin | [Discord-Handler-Kt-Sequelize](https://github.com/RealMtrx/Discord-Handler-Kt-Sequelize) | Exposed |
| 9 | C++ | [Discord-Handler-Cpp-Sequelize](https://github.com/RealMtrx/Discord-Handler-Cpp-Sequelize) | sqlpp11 |
| 10 | Dart | [Discord-Handler-Dart-Sequelize](https://github.com/RealMtrx/Discord-Handler-Dart-Sequelize) | drift |
| 11 | Ruby | [Discord-Handler-Rb-Sequelize](https://github.com/RealMtrx/Discord-Handler-Rb-Sequelize) | Sequel |
| 12 | **Lua** | **Discord-Handler-Lua-Sequelize** | **LuaSQL** |
| 13 | PHP | [Discord-Handler-Php-Sequelize](https://github.com/RealMtrx/Discord-Handler-Php-Sequelize) | Eloquent |

### Hub Repository

<div align="center">
  <a href="https://github.com/RealMtrx/Discord-Handler"><img src="https://img.shields.io/badge/Hub-Discord--Handler-181717?style=for-the-badge&logo=github" alt="Hub Repository"></a>
</div>

The hub repo contains documentation, examples in every language, changelog, roadmap, and contribution guidelines.

## License

Distributed under the MIT License. See `LICENSE` for more information.

---

Built by **Mtrx** — Discord: **0hu2**
