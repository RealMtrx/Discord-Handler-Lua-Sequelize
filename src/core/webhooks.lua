local config = require("config")
local https = require("https")
local webhooks = {}

local function send(url, content)
  if not url or url == "" then
    return
  end
  local payload = { content = tostring(content) }
  local body = require("json").encode(payload)
  local ok, err = https.request(url, "POST", { {"Content-Type", "application/json"}, {"Content-Length", #body} }, body)
  if not ok then
    local logger = require("handlers.logger")
    logger:warn("Webhook send failed: " .. tostring(err))
  end
end

function webhooks:log(msg)
  send(config.webhooks.log, msg)
end

function webhooks:error(msg)
  send(config.webhooks.error, msg)
end

function webhooks:status(msg)
  send(config.webhooks.status, msg)
end

return webhooks
