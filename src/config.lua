local config = {}

local env = {}

local function load_env(path)
  local file, err = io.open(path, "r")
  if not file then
    return
  end
  for line in file:lines() do
    local key, val = line:match("^([%w_]+)%s*=%s*(.+)$")
    if key then
      env[key] = val
    end
  end
  file:close()
end

load_env(".env")

function env:get(key, default)
  return self[key] or default
end

config.token = env:get("BOT_TOKEN")
config.client_id = env:get("CLIENT_ID")
config.guild_id = env:get("GUILD_ID")
config.prefix = env:get("PREFIX", "!")
config.owner_id = env:get("OWNER_ID")
config.status = env:get("STATUS", "online")

config.db = {
  dialect = env:get("DB_DIALECT", "sqlite3"),
  host = env:get("DB_HOST", "localhost"),
  port = tonumber(env:get("DB_PORT", "5432")),
  name = env:get("DB_NAME", "discord_bot"),
  user = env:get("DB_USER", "postgres"),
  pass = env:get("DB_PASS", ""),
}

config.webhooks = {
  log = env:get("WEBHOOK_LOG_URL"),
  error = env:get("WEBHOOK_ERROR_URL"),
  status = env:get("WEBHOOK_STATUS_URL"),
}

return config
