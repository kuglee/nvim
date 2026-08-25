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

    if ok and vim.v.shell_error == 0 and result then
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, result)
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
