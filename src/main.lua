local config = require("config")
local bot = require("bot")
local handlers = require("handlers.anticrash")
local logger = require("handlers.logger")

logger:info("Starting bot...")

bot:on("ready", function()
  logger:info("Bot logged in as " .. bot.user.username)
  require("handlers.events").load(bot)
  require("handlers.commands").load(bot)
  require("handlers.prefix").load(bot)
  bot:setStatus("online", config.status or "online")
end)

bot:run(config.token)
