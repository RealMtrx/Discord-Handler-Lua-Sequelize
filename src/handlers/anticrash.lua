local logger = require("handlers.logger")
local webhooks = require("core.webhooks")

local anticrash = {}

function anticrash.setup()
  xpcall(function()
    local bot = require("bot")
    bot:on("error", function(err)
      logger:error("Unhandled error: " .. tostring(err))
      webhooks:error("Anticrash caught: " .. tostring(err))
    end)
  end, function(err)
    logger:error("Anticrash setup failed: " .. tostring(err))
  end)
end

anticrash.setup()

return anticrash
