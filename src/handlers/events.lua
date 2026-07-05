local logger = require("handlers.logger")

local events = {}

function events:load(bot)
  local event_files = {
    { name = "ready", path = "events.ready" },
    { name = "messageCreate", path = "events.message_create" },
    { name = "interactionCreate", path = "events.interaction_create" },
    { name = "guildCreate", path = "events.guild_create" },
    { name = "guildDelete", path = "events.guild_delete" },
  }

  for _, ev in ipairs(event_files) do
    local ok, handler = pcall(require, ev.path)
    if ok and handler then
      bot:on(ev.name, function(...)
        local ok2, err = pcall(handler, ...)
        if not ok2 then
          logger:error("Error in event " .. ev.name .. ": " .. tostring(err))
        end
      end)
      logger:info("Loaded event: " .. ev.name)
    else
      logger:warn("Failed to load event: " .. ev.path)
    end
  end
end

return events
