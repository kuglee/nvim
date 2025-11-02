vim.pack.add {
  { src = "https://github.com/nvim-telescope/telescope.nvim", version = "0.1.x" },
  "https://github.com/nvim-lua/plenary.nvim",
}

local conf = require("telescope.config").values

require("telescope").setup {
  defaults = {
    vimgrep_arguments = table.insert(conf.vimgrep_arguments, "--fixed-strings"),
    file_ignore_patterns = {
      "^%.build/",
      "^%.git/",
      "^%.idea/",
      "^%.nvim/",
      "^%.swiftpm/",
      "^%.vscode/",
      "^%.xcodeproj/",
      "^%.xcassets/",
    },
    layout_strategy = "vertical",
    layout_config = {
      vertical = {
        mirror = true,
        preview_height = 0.5,
      },
      height = 0.9,
      width = 0.9,
    },
  },
}

local builtin = require "telescope.builtin"

vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fv", builtin.git_files)
vim.keymap.set("n", "<leader>fg", builtin.live_grep)
vim.keymap.set("n", "<leader>fb", builtin.buffers)
vim.keymap.set("n", "<leader>fd", builtin.diagnostics)
vim.keymap.set("n", "gd", builtin.lsp_definitions)
vim.keymap.set("n", "gr", builtin.lsp_references)
