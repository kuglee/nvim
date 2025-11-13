local fmt_group = vim.api.nvim_create_augroup("my.formatters", { clear = true })

local function lsp_format(bufnr)
  bufnr = bufnr or 0
  local clients = vim.lsp.get_clients { bufnr = bufnr }

  for _, client in ipairs(clients) do
    if client:supports_method "textDocument/formatting" then
      vim.lsp.buf.format { async = false, bufnr = bufnr }

      return true
    end
  end

  return false
end

local function format_buffer(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local formatprg = vim.bo[buf].formatprg

  -- Save cursor and view
  local cursor = vim.api.nvim_win_get_cursor(0)
  local view = vim.fn.winsaveview()

  if formatprg ~= "" then
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local text = table.concat(lines, "\n")
    local filepath = vim.api.nvim_buf_get_name(buf)
    local cmd = formatprg:gsub("%%", filepath)

    -- Run formatprg as a job
    local ok, result = pcall(vim.fn.systemlist, cmd, text)
    if ok and vim.v.shell_error == 0 and result then
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, result)
    else
      -- formatprg failed → fallback to LSP
      lsp_format(buf)
    end
  else
    -- No formatprg → fallback to LSP
    lsp_format(buf)
  end

  -- Restore cursor and view
  vim.fn.winrestview(view)
  pcall(vim.api.nvim_win_set_cursor, 0, cursor)
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

    -- Set formatprg on FileType
    vim.api.nvim_create_autocmd("FileType", {
      group = fmt_group,
      pattern = ft,
      callback = function()
        vim.opt_local.formatprg = cmd
      end,
    })

    -- Format on save
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

setup_formatters {
  lua = "stylua -",
  swift = "swiftformat --stdinpath % --quiet",
  -- javascript = {
  --   cmd = "prettier --stdin-filepath %",
  --   extensions = { "*.js", "*.jsx" }
  -- },
}
