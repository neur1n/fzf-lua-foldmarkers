local M = {}

local function collect()
  local marker = vim.api.nvim_get_option_value("foldmarker", {scope = "local"}) or "{{{,}}}"
  local open, close = marker:match("^([^,]+),(.+)$")
  open =  open or "{{{"
  close = close or "}}}"

  local popen = vim.pesc(open)
  local pclose = vim.pesc(close)

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local entries = {}

  for i, line in ipairs(lines) do
    if line:find(popen) or line:find(pclose) then
      local display = line:gsub("^%W+", "")
      table.insert(entries, string.format("%d: %s", i, display))
    end
  end

  return entries
end

function M.foldmarkers()
  local entries = collect()

  if #entries == 0 then
    vim.notify("No fold markers found in current window.", vim.log.levels.INFO)
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()

  require("fzf-lua").fzf_exec(entries, {
    prompt = "Folding Markers> ",
    actions = {
      ["default"] = function(selected)
        local valid = selected and selected[1]
        if not valid then
          return
        end

        local lnum = tonumber(valid:match("^(%d+):"))
        if not lnum then
          return
        end

        vim.api.nvim_win_set_cursor(0, {lnum, 0})
      end,
    },
    preview = function(selected)
      local valid = selected and selected[1]
      if not valid then
        return
      end

      local lnum = tonumber(selected[1]:match("^(%d+):"))
      if not lnum then
        return ""
      end

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local start = math.max(lnum - 5, 1)
      local finish = math.min(lnum + 5, #lines)
      local width = tostring(finish):len()
      local context = {}

      for i = start, finish do
        local num = string.format("%" .. width .. "d", i)

        if i == lnum then
          table.insert(context, string.format("→ %s │ %s", num, lines[i]))
        else
          table.insert(context, string.format("   %s │ %s", num, lines[i]))
        end
      end

      return table.concat(context, "\n")
    end,
  })
end

return M
