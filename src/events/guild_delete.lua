local logger = require("handlers.logger")

return function(guild)
  logger:info("Left guild: " .. guild.name .. " (" .. guild.id .. ")")
end
