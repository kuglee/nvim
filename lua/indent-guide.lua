local augroup = vim.api.nvim_create_augroup("indentlines", {})
local ns = vim.api.nvim_create_namespace "indent_guides"

local function get_guide_char(sw)
  -- Left-aligned options: '▏', '▎', '▍'
  return "▏" .. (" "):rep(sw - 1)
end

local function guides(sw)
  if sw == 0 then
    sw = vim.bo.tabstop
  end
  local char = get_guide_char(sw)
  vim.opt_local.listchars:append { leadmultispace = char }
end

local function draw_empty_line_guides(bufnr, sw)
  -- Skip special buffers
  local buftype = vim.bo[bufnr].buftype
  if buftype ~= "" and buftype ~= "acwrite" then
    return
  end

  if sw == 0 then
    sw = vim.bo[bufnr].tabstop
  end

  -- Clear existing virtual text
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local char = get_guide_char(sw)

  -- Cache indentation levels
  local indent_cache = {}
  for i, line in ipairs(lines) do
    if line ~= "" then
      indent_cache[i] = vim.fn.indent(i)
    end
  end

  for i, line in ipairs(lines) do
    -- Only process empty lines
    if line == "" then
      local indent = 0
      local prev_indent, next_indent

      for j = i - 1, 1, -1 do
        if indent_cache[j] then
          prev_indent = indent_cache[j]
          break
        end
      end

      for j = i + 1, #lines do
        if indent_cache[j] then
          next_indent = indent_cache[j]
          break
        end
      end

      if prev_indent and next_indent then
        indent = math.min(prev_indent, next_indent)
      elseif prev_indent then
        indent = prev_indent
      elseif next_indent then
        indent = next_indent
      end

      if indent > 0 then
        local guide_text = char:rep(math.floor(indent / sw))
        vim.api.nvim_buf_set_extmark(bufnr, ns, i - 1, 0, {
          virt_text = { { guide_text, "Whitespace" } },
          virt_text_pos = "overlay",
          virt_text_repeat_linebreak = true,
        })
      end
    end
  end
end

-- Debounce timer for text changes
local timer = nil
local function debounced_update(bufnr, sw)
  if timer then
    timer:stop()
  end
  timer = vim.defer_fn(function()
    draw_empty_line_guides(bufnr, sw)
    timer = nil
  end, 100)
end

vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "shiftwidth",
  group = augroup,
  callback = function()
    guides(vim.v.option_new)
    draw_empty_line_guides(vim.api.nvim_get_current_buf(), vim.v.option_new)
  end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter", "BufWritePost" }, {
  group = augroup,
  callback = function(args)
    local sw = vim.bo[args.buf].shiftwidth
    guides(sw)
    draw_empty_line_guides(args.buf, sw)
  end,
})

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  group = augroup,
  callback = function(args)
    local sw = vim.bo[args.buf].shiftwidth
    debounced_update(args.buf, sw)
  end,
})
