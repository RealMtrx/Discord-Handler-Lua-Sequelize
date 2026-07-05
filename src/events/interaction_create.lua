local logger = require("handlers.logger")
local cooldown = require("core.cooldown")

return function(interaction)
  if interaction.type ~= 2 then
    return
  end

  local cmd_name = interaction.data.name
  local cmd_path = "commands.slash.public." .. cmd_name

  local ok, cmd = pcall(require, cmd_path)
  if not ok or not cmd then
    interaction:reply({ content = "Command not found.", ephemeral = true })
    return
  end

  if cooldown:check(interaction.member.user.id, cmd_name) then
    interaction:reply({
      content = "Please wait " .. cooldown.remaining(interaction.member.user.id, cmd_name) .. " seconds.",
      ephemeral = true,
    })
    return
  end

  local options = {}
  if interaction.data.options then
    for _, opt in ipairs(interaction.data.options) do
      options[opt.name] = opt.value
    end
  end

  local success, err = pcall(cmd.execute, interaction, options)
  if not success then
    logger:error("Slash command error (" .. cmd_name .. "): " .. tostring(err))
    interaction:reply({ content = "An error occurred.", ephemeral = true })
  else
    cooldown:set(interaction.member.user.id, cmd_name)
  end
end
