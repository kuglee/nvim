vim.pack.add {
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/nvim-mini/mini.icons",
}

require("mini.icons").setup()

require("oil").setup {
  delete_to_trash = true,
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
  },
}
