local emojis = require("core.emojis")

local cmd = {}

function cmd.execute(msg, args)
  local latency = math.floor(msg.client.ping or 0)
  msg:reply(emojis:get("ping") .. " Pong! Latency: " .. latency .. "ms")
end

return cmd
