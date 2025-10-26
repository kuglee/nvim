-- from: https://github.com/juniorsundar/nvim/blob/679acb2e259f23a55fc87ba837bab18705cfc3e7/lua/config/lsp/breadcrumbs.lua
local SymbolKind = vim.lsp.protocol.SymbolKind

local symbol_kinds = {
  [SymbolKind.File] = "󰈙",
  [SymbolKind.Module] = "",
  [SymbolKind.Namespace] = "",
  [SymbolKind.Package] = "",
  [SymbolKind.Class] = "󰠱",
  [SymbolKind.Method] = "󰆧",
  [SymbolKind.Property] = "󰜢",
  [SymbolKind.Field] = "󰜢",
  [SymbolKind.Constructor] = "󱌣",
  [SymbolKind.Enum] = "󰉺",
  [SymbolKind.Interface] = "󰕣",
  [SymbolKind.Function] = "󰊕",
  [SymbolKind.Variable] = "󰀫",
  [SymbolKind.Constant] = "󰏿",
  [SymbolKind.String] = "󰉿",
  [SymbolKind.Number] = "󰎠",
  [SymbolKind.Boolean] = "󰨙",
  [SymbolKind.Array] = "󰅪",
  [SymbolKind.Object] = "󰅩",
  [SymbolKind.Key] = "󰌋",
  [SymbolKind.Null] = "󰟢",
  [SymbolKind.EnumMember] = "󰧟",
  [SymbolKind.Struct] = "󰙅",
  [SymbolKind.Event] = "",
  [SymbolKind.Operator] = "󰆕",
  [SymbolKind.TypeParameter] = "",
}

local function range_contains_pos(range, line, char)
  local start = range.start
  local stop = range["end"]

  if line < start.line or line > stop.line then
    return false
  end

  if line == start.line and char < start.character then
    return false
  end

  if line == stop.line and char > stop.character then
    return false
  end

  return true
end

local function find_symbol_path(symbol_list, line, char, path)
  if not symbol_list or #symbol_list == 0 then
    return false
  end
  for _, symbol in ipairs(symbol_list) do
    if range_contains_pos(symbol.range, line, char) then
      local icon = symbol_kinds[symbol.kind]
      local prefix = (icon and icon ~= "") and (icon .. " ") or ""
      table.insert(path, prefix .. symbol.name)
      find_symbol_path(symbol.children, line, char, path)
      return true
    end
  end
  return false
end

local function lsp_callback(err, symbols, ctx)
  if err or not symbols then
    vim.o.winbar = ""
    return
  end

  local file_path = vim.api.nvim_buf_get_name(ctx.bufnr)
  if not file_path or file_path == "" then
    vim.o.winbar = "[No Name]"
    return
  end

  local pos = vim.api.nvim_win_get_cursor(0)
  local cursor_line = pos[1] - 1
  local cursor_char = pos[2]

  local stat = vim.loop.fs_stat(file_path)
  local is_dir = stat and stat.type == "directory"

  local relative_path = file_path

  local clients = vim.lsp.get_clients { bufnr = ctx.bufnr }

  if #clients > 0 and clients[1].root_dir then
    local root_dir = clients[1].root_dir
    if root_dir and root_dir ~= "" then
      local ok, rel = pcall(vim.fs.relpath, root_dir, file_path)
      if ok and rel and rel ~= "" then
        relative_path = rel
      end
    end
  end

  local parts = vim.split(relative_path, "/", { trimempty = true })
  if #parts == 0 then
    vim.o.winbar = (is_dir and "󰉋 " or "󰈔 ") .. relative_path
    return
  end

  local formatted = {}
  for i, part in ipairs(parts) do
    local is_last = (i == #parts)
    if is_last then
      if is_dir then
        table.insert(formatted, "󰉋 " .. part)
      else
        table.insert(formatted, "󰈔 " .. part)
      end
    else
      table.insert(formatted, "󰉋 " .. part)
    end
  end

  local display_path = table.concat(formatted, "  ")

  local breadcrumbs = { display_path }

  find_symbol_path(symbols, cursor_line, cursor_char, breadcrumbs)

  local breadcrumb_string = table.concat(breadcrumbs, "  ")

  if breadcrumb_string ~= "" then
    vim.o.winbar = breadcrumb_string
  else
    vim.o.winbar = " "
  end
end

local function breadcrumbs_set()
  local bufnr = vim.api.nvim_get_current_buf()
  local uri = vim.lsp.util.make_text_document_params(bufnr)["uri"]
  if not uri then
    vim.print "Error: Could not get URI for buffer. Is it saved?"
    return
  end

  local params = {
    textDocument = {
      uri = uri,
    },
  }
  vim.lsp.buf_request(bufnr, "textDocument/documentSymbol", params, lsp_callback)
end

local breadcrumbs_augroup = vim.api.nvim_create_augroup("Breadcrumbs", { clear = true })

vim.api.nvim_create_autocmd({ "CursorMoved" }, {
  group = breadcrumbs_augroup,
  callback = breadcrumbs_set,
  desc = "Set breadcrumbs.",
})
