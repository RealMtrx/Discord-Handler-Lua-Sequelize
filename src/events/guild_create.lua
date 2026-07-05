local logger = require("handlers.logger")

return function(guild)
  logger:info("Joined guild: " .. guild.name .. " (" .. guild.id .. ")")
end
