local emojis = {
  success = "<a:check:1234567890>",
  error = "<a:cross:1234567890>",
  loading = "<a:loading:1234567890>",
  warning = "<a:warning:1234567890>",
  info = "<:info:1234567890>",
  ping = "<:ping_pong:1234567890>",
}

function emojis:get(name)
  return self[name] or ""
end

return emojis
