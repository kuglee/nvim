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

vim.opt.completeopt = { "menu", "menuone", "noinsert" }
vim.opt.pumheight = 10 -- maximum number of items to show in popup menu

-- use Esc to cancel completion without accepting
vim.keymap.set("i", "<Esc>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-e><Esc>"
  end
  return "<Esc>"
end, { expr = true, desc = "Cancel completion" })

-- native autocompletion
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my.lsp", {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method "textDocument/completion" then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})
