local fmt_group = vim.api.nvim_create_augroup("my.formatters", { clear = true })

local function lsp_format(bufnr)
  bufnr = bufnr or 0
  local clients = vim.lsp.get_clients { bufnr = bufnr }

  for _, client in ipairs(clients) do
    if client:supports_method "textDocument/formatting" then
      vim.lsp.buf.format {
        async = false,
        bufnr = bufnr,
        id = client.id,
      }

      return true
    end
  end

  return false
end

-- Replace only the lines that actually changed, instead of nuking the whole
-- buffer with nvim_buf_set_lines(buf, 0, -1, ...). A full-buffer replace
-- makes Neovim treat every line as deleted+recreated, which collapses any
-- jumplist entries in that buffer down to line 1 (winrestview only fixes the
-- *current* cursor, not stale jumplist marks). Diffing preserves the
-- identity of unchanged lines so marks/jumplist stay correct.
local function set_lines_diff(buf, new_lines)
  local old_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local old_text = table.concat(old_lines, "\n") .. "\n"
  local new_text = table.concat(new_lines, "\n") .. "\n"

  if old_text == new_text then
    return
  end

  local diff = vim.diff(old_text, new_text, {
    result_type = "indices",
    algorithm = "histogram",
  })

  if not diff then
    -- Fallback: no diff available, do the old (buggy but functional) thing.
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, new_lines)
    return
  end

  -- Apply hunks back-to-front so earlier edits don't shift line numbers
  -- for hunks we haven't applied yet.
  for i = #diff, 1, -1 do
    local start_a, count_a, start_b, count_b = unpack(diff[i])

    local replacement = {}
    for j = start_b, start_b + count_b - 1 do
      table.insert(replacement, new_lines[j])
    end

    local a_start = count_a > 0 and (start_a - 1) or start_a
    local a_end = count_a > 0 and (start_a - 1 + count_a) or start_a

    if i < #diff then
      -- Merge into the same undo step as the previously-applied hunk,
      -- so a whole-file format is still a single `u` away.
      pcall(vim.cmd, "silent! undojoin")
    end
    vim.api.nvim_buf_set_lines(buf, a_start, a_end, false, replacement)
  end
end

local function format_buffer(buf)
  buf = buf or vim.api.nvim_get_current_buf()

  local view = vim.fn.winsaveview()
  local formatprg = vim.bo[buf].formatprg

  if formatprg ~= "" then
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local text = table.concat(lines, "\n")
    local filepath = vim.api.nvim_buf_get_name(buf)
    local cmd = formatprg:gsub("%%", filepath)

    local ok, result = pcall(vim.fn.systemlist, cmd, text)

    if ok and vim.v.shell_error == 0 and result and #result > 0 then
      set_lines_diff(buf, result)
    else
      lsp_format(buf)
    end
  else
    lsp_format(buf)
  end

  vim.fn.winrestview(view)
end

local function setup_formatters(formatters)
  for ft, config in pairs(formatters) do
    local cmd
    local patterns

    if type(config) == "string" then
      cmd = config
      patterns = { "*." .. ft }
    else
      cmd = config.cmd
      patterns = config.extensions or { "*." .. ft }
    end

    -- Only set formatprg when an external formatter was configured.
    -- An empty config (e.g. php = {}) means "use LSP".
    if cmd then
      vim.api.nvim_create_autocmd("FileType", {
        group = fmt_group,
        pattern = ft,
        callback = function()
          vim.opt_local.formatprg = cmd
        end,
      })
    end

    -- Format on save.
    for _, pat in ipairs(patterns) do
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = fmt_group,
        pattern = pat,
        callback = function()
          format_buffer(vim.api.nvim_get_current_buf())
        end,
      })
    end
  end
end

-- Formatters
setup_formatters {
  elm = "elm-format --stdin",
  lua = "stylua -",
  swift = "swiftformat --stdinpath % --quiet",
  javascript = {
    cmd = "npx biome format --write %",
    extensions = { "*.js", "*.jsx", "*.ts", "*.tsx" },
  },
}
