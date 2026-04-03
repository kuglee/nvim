vim.pack.add {
  "https://github.com/barrettruth/canola.nvim",
  "https://github.com/nvim-mini/mini.icons",
}

require("mini.icons").setup()

require("oil").setup {
  delete_to_trash = true,
  columns = {
    "icon",
    -- "permissions",
    -- "size",
    -- "mtime",
  },
  constrain_cursor = "name",
  lsp_file_methods = {
    enabled = false,
  },
  use_default_keymaps = false,
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = "actions.close",
    ["<C-l>"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["gs"] = "actions.change_sort",
    ["gx"] = "actions.open_external",
    ["g."] = "actions.toggle_hidden",
    ["g\\"] = "actions.toggle_trash",
    ["<leader>yy"] = {
      desc = "Copy filepath to system clipboard",
      callback = function()
        require("oil.actions").copy_to_system_clipboard.callback()
      end,
    },
    ["<leader>yp"] = {
      desc = "Copy filepath to system clipboard",
      callback = function()
        require("oil.actions").paste_from_system_clipboard.callback()
      end,
    },
  },
}
