local logger = {}

local function timestamp()
  return os.date("%Y-%m-%d %H:%M:%S")
end

function logger:info(msg)
  print("[" .. timestamp() .. "] [INFO] " .. msg)
end

function logger:warn(msg)
  print("[" .. timestamp() .. "] [WARN] " .. msg)
end

function logger:error(msg)
  print("[" .. timestamp() .. "] [ERROR] " .. msg)
end

function logger:debug(msg)
  print("[" .. timestamp() .. "] [DEBUG] " .. msg)
end

return logger
