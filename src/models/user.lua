local db = require("database.init")
local User = {}

function User:create(data)
  local id = db:escape(data.id)
  local username = db:escape(data.username)
  local discriminator = db:escape(data.discriminator or "0")
  local avatar = db:escape(data.avatar or "")
  local bot = data.bot and 1 or 0

  local sql = string.format(
    "INSERT INTO users (id, username, discriminator, avatar, bot) VALUES ('%s', '%s', '%s', '%s', %s) ON CONFLICT(id) DO UPDATE SET username=excluded.username, discriminator=excluded.discriminator, avatar=excluded.avatar, bot=excluded.bot",
    id, username, discriminator, avatar, bot
  )
  return db:execute(sql)
end

function User:find(id)
  local escaped = db:escape(tostring(id))
  local rows = db:query("SELECT * FROM users WHERE id = '" .. escaped .. "'")
  return rows and rows[1]
end

function User:findOrCreate(data)
  local user = self:find(data.id)
  if user then
    return user
  end
  self:create(data)
  return self:find(data.id)
end

function User:update(id, fields)
  local parts = {}
  for k, v in pairs(fields) do
    table.insert(parts, k .. " = '" .. db:escape(tostring(v)) .. "'")
  end
  local escaped_id = db:escape(tostring(id))
  local sql = "UPDATE users SET " .. table.concat(parts, ", ") .. " WHERE id = '" .. escaped_id .. "'"
  return db:execute(sql)
end

function User:delete(id)
  local escaped = db:escape(tostring(id))
  return db:execute("DELETE FROM users WHERE id = '" .. escaped .. "'")
end

function User:all()
  return db:query("SELECT * FROM users ORDER BY created_at DESC")
end

return User
