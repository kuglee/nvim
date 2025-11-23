vim.opt.completeopt = { "menu", "menuone", "noinsert", "popup" }
vim.opt.pumheight = 10 -- maximum number of items to show in popup menu

-- use Esc to cancel completion without accepting
vim.keymap.set("i", "<Esc>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-e><Esc>"
  end
  return "<Esc>"
end, { expr = true, desc = "Cancel completion" })

-- from: https://github.com/konradmalik/neovim-flake/blob/c999043374eb4ef675271571f1d3c8d1932f805c/config/nvim/lua/pde/lsp/capabilities/textDocument_completion.lua
local CompletionItemKind = vim.lsp.protocol.CompletionItemKind
local kind_icons = {
  [CompletionItemKind.Class] = { color = "Type", icon = "􀂙 " },
  [CompletionItemKind.Color] = { color = "None", icon = "􁙨 " },
  [CompletionItemKind.Constant] = { color = "Constant", icon = "􀀉 " },
  [CompletionItemKind.Constructor] = { color = "Function", icon = "􀣌 " },
  [CompletionItemKind.Enum] = { color = "Enum", icon = "􀂝 " },
  [CompletionItemKind.EnumMember] = { color = "Constant", icon = "􀀍 " },
  [CompletionItemKind.Event] = { color = "None", icon = "􀼶 " },
  [CompletionItemKind.Field] = { color = "Field", icon = "􀂟 " },
  [CompletionItemKind.File] = { color = "File", icon = "􀉀 " },
  [CompletionItemKind.Folder] = { color = "None", icon = "􀈖 " },
  [CompletionItemKind.Function] = { color = "Function", icon = "􀗢 " },
  [CompletionItemKind.Interface] = { color = "Type", icon = "􀂥 " },
  [CompletionItemKind.Keyword] = { color = "None", icon = "􀀯 " },
  [CompletionItemKind.Method] = { color = "Function", icon = "􀂭 " },
  [CompletionItemKind.Module] = { color = "Module", icon = "􀐛 " },
  [CompletionItemKind.Operator] = { color = "Operator", icon = "􀅺 " },
  [CompletionItemKind.Property] = { color = "Property", icon = "􀂳 " },
  [CompletionItemKind.Reference] = { color = "None", icon = "􀀯 " },
  [CompletionItemKind.Snippet] = { color = "None", icon = "􀀩 " },
  [CompletionItemKind.Struct] = { color = "Structure", icon = "􀂹 " },
  [CompletionItemKind.Text] = { color = "String", icon = "􂐦 " },
  [CompletionItemKind.TypeParameter] = { color = "None", icon = "􀸏 " },
  [CompletionItemKind.Unit] = { color = "Module", icon = "􀐛 " },
  [CompletionItemKind.Value] = { color = "None", icon = "􀀯 " },
  [CompletionItemKind.Variable] = { color = "None", icon = "􀀯 " },
}

---@param docs string
---@param client string
---@param detail string?
---@param width integer
local function format_docs(docs, client, detail, width)
  local formatted = docs
  local content_width = width

  if detail then
    formatted = detail .. "\n" .. string.rep("─", content_width) .. "\n\n" .. formatted
  end

  return formatted .. "\n\n_client: " .. client .. "_"
end

---@param selected_index integer
---@param result table
---@param client string
---@param detail string?
---@param win_max_width integer
local function show_documentation(selected_index, result, client, detail, win_max_width)
  local docs = vim.tbl_get(result, "documentation", "value")
  if not docs then
    return
  end

  -- Get the window width
  local wininfo =
    vim.api.nvim__complete_set(selected_index, { info = format_docs(docs, client, detail, 0) })
  if vim.tbl_isempty(wininfo) or not vim.api.nvim_win_is_valid(wininfo.winid) then
    return
  end

  local config = vim.api.nvim_win_get_config(wininfo.winid)
  config.width = math.min(config.width, win_max_width)
  config.border = { "", "", "", " ", "", "", "", " " }

  -- Recreate the window with the correct width
  wininfo = vim.api.nvim__complete_set(
    selected_index,
    { info = format_docs(docs, client, detail, config.width) }
  )
  if vim.tbl_isempty(wininfo) or not vim.api.nvim_win_is_valid(wininfo.winid) then
    return
  end

  config.col = (config.col or 0) + 1 -- offset the window to fix overlap with the completion window
  config.fixed = true -- prevent automatic repositioning because of long lines
  vim.api.nvim_win_set_config(wininfo.winid, config)

  vim.wo[wininfo.winid].conceallevel = 2
  vim.wo[wininfo.winid].concealcursor = "n"

  if not vim.api.nvim_buf_is_valid(wininfo.bufnr) then
    return
  end

  vim.bo[wininfo.bufnr].syntax = "markdown"
  vim.treesitter.start(wininfo.bufnr, "markdown")
end

---@param client string
---@param augroup integer
---@param bufnr integer
local function enable_completion_documentation(client, augroup, bufnr)
  local _, cancel_prev = nil, function() end

  vim.api.nvim_create_autocmd("CompleteChanged", {
    group = augroup,
    buffer = bufnr,
    callback = function()
      cancel_prev()

      local completion_item =
        vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "completion_item")
      if not completion_item then
        return
      end

      local complete_info = vim.fn.complete_info { "selected" }
      if vim.tbl_isempty(complete_info) then
        return
      end

      local selected_index = complete_info.selected
      local detail = completion_item.detail
        or (completion_item.kind and vim.lsp.protocol.CompletionItemKind[completion_item.kind])
        or nil

      _, cancel_prev = vim.lsp.buf_request(
        bufnr,
        vim.lsp.protocol.Methods.completionItem_resolve,
        completion_item,
        function(err, item)
          if err ~= nil then
            vim.notify(
              "Error from client " .. client .. " when getting documentation\n" .. vim.inspect(err),
              vim.log.levels.WARN
            )

            return
          end
          if not item then
            return
          end

          show_documentation(selected_index, item, client, detail, 80)
        end
      )
    end,
  })
end

-- Native autocompletion
local autogroup = vim.api.nvim_create_augroup("my.lsp", {})
vim.api.nvim_create_autocmd("LspAttach", {
  group = autogroup,
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method "textDocument/completion" then
      vim.lsp.completion.enable(true, client.id, args.buf, {
        autotrigger = true,
        convert = function(item)
          --- @param str string
          --- @param max_length number
          local function truncate_string(str, max_length)
            if #str > max_length then
              return str:sub(1, max_length - 3) .. "..."
            end
            return str
          end

          return {
            abbr = kind_icons[item.kind].icon,
            abbr_hlgroup = kind_icons[item.kind].color,
            kind = truncate_string(item.label, 50),
            menu = "",
            info = "",
          }
        end,
      })
    end

    enable_completion_documentation(client.name, autogroup, args.buf)
  end,
})
