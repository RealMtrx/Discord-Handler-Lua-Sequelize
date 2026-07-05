local logger = require("handlers.logger")
local config = require("config")

local commands = {}

function commands:load(bot)
  local files = {
    "commands.slash.public.ping",
  }

  local registry = {}

  for _, path in ipairs(files) do
    local ok, cmd = pcall(require, path)
    if ok and cmd and cmd.data then
      table.insert(registry, cmd.data)
      logger:info("Loaded slash command: " .. (cmd.data.name or "unknown"))
    else
      logger:warn("Failed to load slash command: " .. path)
    end
  end

  local guild_id = config.guild_id
  if guild_id and guild_id ~= "" then
    local guild = bot:getGuild(guild_id)
    if guild then
      guild:bulkOverwriteApplicationCommands(registry)
      logger:info("Registered " .. #registry .. " slash commands in guild " .. guild_id)
    end
  else
    -- Global registration would need REST API call
    logger:warn("GUILD_ID not set; skipping slash command registration")
  end

  bot._slash_commands = registry
end

return commands
