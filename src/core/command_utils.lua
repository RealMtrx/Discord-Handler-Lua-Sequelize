local utils = {}

function utils:split(str, delim)
  local parts = {}
  local pattern = "[^" .. delim .. "]+"
  for part in str:gmatch(pattern) do
    table.insert(parts, part)
  end
  return parts
end

function utils:truncate(str, len)
  if #str > len then
    return str:sub(1, len - 3) .. "..."
  end
  return str
end

function utils:cleanContent(content)
  return content:gsub("<@!?%d+>", ""):gsub("<#%d+>", ""):gsub("<a?:%w+:%d+>", ""):gsub("%s+", " "):match("^%s*(.-)%s*$")
end

function utils:embed(title, description, color)
  return {
    title = title,
    description = description,
    color = color or 0x5865F2,
    timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
  }
end

function utils:paginate(list, page, per_page)
  per_page = per_page or 10
  page = math.max(page or 1, 1)
  local total = #list
  local total_pages = math.max(math.ceil(total / per_page), 1)
  page = math.min(page, total_pages)
  local start_idx = (page - 1) * per_page + 1
  local end_idx = math.min(start_idx + per_page - 1, total)
  return {
    items = { select(list, start_idx, end_idx) },
    page = page,
    total_pages = total_pages,
    total = total,
    has_next = page < total_pages,
    has_prev = page > 1,
  }
end

return utils
