-- icons for completion item kinds
local kind_icons = {
  Text = "󰉿",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰜢",
  Variable = "󰀫",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "󰈇",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "",
}

-- apply icons only (no kind text)
for kind, icon in pairs(kind_icons) do
  local kind_id = vim.lsp.protocol.CompletionItemKind[kind]
  if kind_id then
    vim.lsp.protocol.CompletionItemKind[kind_id] = icon
  end
end

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
local function format_docs(docs, client)
  return docs .. "\n\n_client: " .. client .. "_"
end

---@param selected_index integer
---@param result table
---@param client string
local function show_documentation(selected_index, result, client)
  local docs = vim.tbl_get(result, "documentation", "value")
  if not docs then
    return
  end

  local wininfo = vim.api.nvim__complete_set(selected_index, { info = format_docs(docs, client) })
  if vim.tbl_isempty(wininfo) or not vim.api.nvim_win_is_valid(wininfo.winid) then
    return
  end

  local config = vim.api.nvim_win_get_config(wininfo.winid)
  config.col = (config.col or 0) + 2 -- offset the window to fix overlap with the completion window
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

local documentation_is_enabled = true

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
      if not documentation_is_enabled then
        return
      end

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
            -- at this stage just disable it
            documentation_is_enabled = false
            return
          end
          if not item then
            return
          end

          show_documentation(selected_index, item, client)
        end
      )
    end,
  })
end

-- native autocompletion
local autogroup = vim.api.nvim_create_augroup("my.lsp", {})
vim.api.nvim_create_autocmd("LspAttach", {
  group = autogroup,
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method "textDocument/completion" then
      vim.lsp.completion.enable(true, client.id, args.buf, {
        autotrigger = true,
        -- convert = function(item)
        --   return {
        --     abbr = #item.label > 50 and item.label:sub(1, 47) .. "..." or item.label,
        --   }
        -- end,
      })
    end

    if client:supports_method(vim.lsp.protocol.Methods.completionItem_resolve, args.buf) then
      enable_completion_documentation(client.name, autogroup, args.buf)
    end
  end,
})
