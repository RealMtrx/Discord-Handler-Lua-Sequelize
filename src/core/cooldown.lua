local cooldowns = {}
local default_time = 3

local cooldown = {}

function cooldown:set(user_id, cmd_name, time)
  local key = user_id .. ":" .. cmd_name
  cooldowns[key] = os.time() + (time or default_time)
end

function cooldown:check(user_id, cmd_name)
  local key = user_id .. ":" .. cmd_name
  local expiry = cooldowns[key]
  if not expiry then
    return false
  end
  return os.time() < expiry
end

function cooldown:remaining(user_id, cmd_name)
  local key = user_id .. ":" .. cmd_name
  local expiry = cooldowns[key]
  if not expiry then
    return 0
  end
  return math.max(0, expiry - os.time())
end

function cooldown:clear(user_id, cmd_name)
  local key = user_id .. ":" .. cmd_name
  cooldowns[key] = nil
end

return cooldown
