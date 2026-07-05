local config = require("config")
local db = {}

local luasql

if config.db.dialect == "sqlite3" then
  luasql = require("luasql.sqlite3")
  db.env = luasql.sqlite3()
  db.con = db.env:connect(config.db.name .. ".db")
elseif config.db.dialect == "postgres" then
  luasql = require("luasql.postgres")
  db.env = luasql.postgres()
  db.con = db.env:connect(config.db.name, config.db.user, config.db.pass, config.db.host, config.db.port)
else
  error("Unsupported DB_DIALECT: " .. config.db.dialect)
end

function db:query(sql)
  local cursor, err = self.con:execute(sql)
  if not cursor then
    return nil, err
  end
  if type(cursor) == "userdata" then
    local rows = {}
    local row = cursor:fetch({}, "a")
    while row do
      table.insert(rows, row)
      row = cursor:fetch({}, "a")
    end
    cursor:close()
    return rows
  end
  return cursor
end

function db:execute(sql)
  local ok, err = self.con:execute(sql)
  if not ok then
    return nil, err
  end
  return ok
end

function db:escape(val)
  return self.con:escape(tostring(val))
end

function db:close()
  self.con:close()
  self.env:close()
end

local function init_tables()
  if config.db.dialect == "sqlite3" then
    db:execute([[
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        username TEXT NOT NULL,
        discriminator TEXT,
        avatar TEXT,
        bot INTEGER DEFAULT 0,
        created_at TEXT DEFAULT (datetime('now'))
      )
    ]])
  elseif config.db.dialect == "postgres" then
    db:execute([[
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        username TEXT NOT NULL,
        discriminator TEXT,
        avatar TEXT,
        bot BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT NOW()
      )
    ]])
  end
end

init_tables()

return db
