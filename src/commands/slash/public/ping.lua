local emojis = require("core.emojis")

local cmd = {
  data = {
    name = "ping",
    description = "Check the bot's latency",
    type = 1,
  },
}

function cmd.execute(interaction, options)
  local latency = math.floor(interaction.client.ping or 0)
  interaction:reply({
    content = emojis:get("ping") .. " Pong! Latency: " .. latency .. "ms",
    ephemeral = false,
  })
end

return cmd
