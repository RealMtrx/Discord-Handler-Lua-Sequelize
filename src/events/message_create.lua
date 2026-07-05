local User = require("models.user")

return function(msg)
  if msg.author.bot then
    return
  end

  User:findOrCreate({
    id = msg.author.id,
    username = msg.author.username,
    discriminator = msg.author.discriminator,
    avatar = msg.author.avatar,
    bot = msg.author.bot,
  })
end
