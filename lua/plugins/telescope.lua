return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local telescope = require "telescope"
    local builtin = require "telescope.builtin"
    local conf = require("telescope.config").values

    telescope.setup {
      defaults = {
        vimgrep_arguments = table.insert(conf.vimgrep_arguments, "--fixed-strings"),
        file_ignore_patterns = {
          ".build",
          ".git",
          ".idea",
          ".nvim",
          ".swiftpm",
          ".vscode",
          ".xcodeproj",
          ".xcassets",
        },
      },
    }

    vim.keymap.set("n", "<leader>ff", builtin.find_files)
    vim.keymap.set("n", "<leader>fv", builtin.git_files)
    vim.keymap.set("n", "<leader>fg", builtin.live_grep)
    vim.keymap.set("n", "<leader>fb", builtin.buffers)
    vim.keymap.set("n", "<leader>fd", builtin.diagnostics)
  end,
}
