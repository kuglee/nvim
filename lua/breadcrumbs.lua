-- based on: https://github.com/juniorsundar/nvim/blob/ec45d4572e99769278e26dee76c0830d3f68f414/lua/config/lsp/breadcrumbs.lua

local folder_icon = "%#Conditional#" .. "󰉋" .. "%*"
local file_icon = "󰈔"

local SymbolKind = vim.lsp.protocol.SymbolKind
local kind_icons = {
  [SymbolKind.File] = "%#File#" .. "󰈔" .. "%*",
  [SymbolKind.Module] = "%#Module#" .. "󰏗" .. "%*",
  [SymbolKind.Namespace] = "%#Structure#" .. "󰅩" .. "%*",
  [SymbolKind.Package] = "󰏗",
  [SymbolKind.Class] = "%#Class#" .. "" .. "%*",
  [SymbolKind.Method] = "%#Function#" .. "󰆧" .. "%*",
  [SymbolKind.Property] = "%#Property#" .. "" .. "%*",
  [SymbolKind.Field] = "%#Field#" .. "" .. "%*",
  [SymbolKind.Constructor] = "%#Function#" .. "" .. "%*",
  [SymbolKind.Enum] = "%#Enum#" .. "" .. "%*",
  [SymbolKind.Interface] = "%#Type#" .. "" .. "%*",
  [SymbolKind.Function] = "%#Function#" .. "󰊕" .. "%*",
  [SymbolKind.Variable] = "%#None#" .. "󰀫" .. "%*",
  [SymbolKind.Constant] = "%#Constant#" .. "󰏿" .. "%*",
  [SymbolKind.String] = "%#String#" .. "" .. "%*",
  [SymbolKind.Number] = "%#Number#" .. "󰎠" .. "%*",
  [SymbolKind.Boolean] = "%#Boolean#" .. "" .. "%*",
  [SymbolKind.Array] = "%#Array#" .. "󰅪" .. "%*",
  [SymbolKind.Object] = "%#Class#" .. "󰅩" .. "%*",
  [SymbolKind.Key] = "%#Keyword#" .. "󰌋" .. "%*",
  [SymbolKind.Null] = "󰢤",
  [SymbolKind.EnumMember] = "",
  [SymbolKind.Struct] = "%#Structure#" .. "" .. "%*",
  [SymbolKind.Event] = "",
  [SymbolKind.Operator] = "",
  [SymbolKind.TypeParameter] = "󰅲",
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
      local icon = kind_icons[symbol.kind]
      local prefix = (icon and icon ~= "") and (icon .. " ") or ""
      table.insert(path, prefix .. symbol.name)
      find_symbol_path(symbol.children, line, char, path)
      return true
    end
  end
  return false
end

local function get_relative_file_path(file_path)
  local clients = vim.lsp.get_clients { bufnr = 0 }
  local root_dir = (clients[1] and clients[1].root_dir and clients[1].root_dir ~= "")
      and clients[1].root_dir
    or vim.fn.getcwd(0)

  local ok, rel = pcall(vim.fs.relpath, file_path, root_dir)
  local relative_path = (ok and rel and rel ~= "") and rel or file_path

  return relative_path
end

local function lsp_callback(err, symbols, ctx)
  if err or not symbols then
    vim.o.winbar = ""
    return
  end

  local file_path = vim.fn.bufname(ctx.bufnr)
  if not file_path or file_path == "" then
    vim.o.winbar = "[No Name]"
    return
  end

  local winnr = vim.api.nvim_get_current_win()
  local pos = vim.api.nvim_win_get_cursor(0)
  local cursor_line = pos[1] - 1
  local cursor_char = pos[2]

  local stat = vim.loop.fs_stat(file_path)
  local is_dir = stat and stat.type == "directory"

  local relative_path = get_relative_file_path(file_path)

  local breadcrumbs = {}

  local path_components = vim.split(relative_path, "[/\\]", { trimempty = true })
  local num_components = #path_components

  for i, component in ipairs(path_components) do
    local is_last = (i == num_components)
    local icon = (is_last and not is_dir) and file_icon or folder_icon

    table.insert(breadcrumbs, icon .. " " .. component)
  end

  find_symbol_path(symbols, cursor_line, cursor_char, breadcrumbs)

  local breadcrumb_string = table.concat(breadcrumbs, " > ")

  if breadcrumb_string ~= "" then
    vim.api.nvim_set_option_value("winbar", breadcrumb_string, { win = winnr })
  else
    vim.api.nvim_set_option_value("winbar", " ", { win = winnr })
  end
end

local function breadcrumbs_set()
  local bufnr = vim.api.nvim_get_current_buf()
  ---@type string
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

  local buf_src = uri:sub(1, uri:find ":" - 1)
  if buf_src ~= "file" then
    vim.o.winbar = ""
    return
  end

  vim.lsp.buf_request(bufnr, "textDocument/documentSymbol", params, lsp_callback)
end

local breadcrumbs_augroup = vim.api.nvim_create_augroup("Breadcrumbs", { clear = true })

vim.api.nvim_create_autocmd({ "CursorMoved" }, {
  group = breadcrumbs_augroup,
  callback = breadcrumbs_set,
  desc = "Set breadcrumbs.",
})

vim.api.nvim_create_autocmd({ "WinLeave" }, {
  group = breadcrumbs_augroup,
  callback = function()
    vim.o.winbar = ""
  end,
  desc = "Clear breadcrumbs when leaving window.",
})
