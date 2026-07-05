local discordia = require("discordia")
local bot = discordia.Client()

bot:on("error", function(err)
  local logger = require("handlers.logger")
  logger:error("Client error: " .. tostring(err))
end)

return bot
