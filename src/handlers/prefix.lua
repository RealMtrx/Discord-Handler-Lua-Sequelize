local logger = require("handlers.logger")
local cooldown = require("core.cooldown")
local config = require("config")

local prefix = {}

function prefix:load(bot)
  bot:on("messageCreate", function(msg)
    if msg.author.bot then
      return
    end

    local content = msg.content
    if not content:find("^" .. config.prefix) then
      return
    end

    local args = {}
    for arg in content:gmatch("%S+") do
      table.insert(args, arg)
    end

    local cmd_name = args[1]:sub(#config.prefix + 1):lower()
    table.remove(args, 1)

    local cmd_path = "commands.prefix." .. (msg.channel.type == 1 and "dm" or "public") .. "." .. cmd_name
    local ok, cmd = pcall(require, cmd_path)
    if not ok or not cmd then
      -- Try commands.prefix.public.<name> as fallback
      cmd_path = "commands.prefix.public." .. cmd_name
      ok, cmd = pcall(require, cmd_path)
    end

    if ok and cmd and cmd.execute then
      if cooldown:check(msg.author.id, cmd_name) then
        msg:reply("Please wait " .. cooldown.remaining(msg.author.id, cmd_name) .. " seconds before using this command again.")
        return
      end

      local success, err = pcall(cmd.execute, msg, args)
      if not success then
        logger:error("Prefix command error (" .. cmd_name .. "): " .. tostring(err))
        msg:reply("An error occurred while executing that command.")
      else
        cooldown:set(msg.author.id, cmd_name)
      end
    end
  end)
end

return prefix
