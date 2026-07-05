local logger = require("handlers.logger")
local webhooks = require("core.webhooks")

return function()
  logger:info("Bot is ready")
  webhooks:status("Bot is online")
end
