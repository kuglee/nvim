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

    vim.keymap.set("n", "<leader>ff", builtin.find_files)
    vim.keymap.set("n", "<leader>fv", builtin.git_files)
    vim.keymap.set("n", "<leader>fg", builtin.live_grep)
    vim.keymap.set("n", "<leader>fb", builtin.buffers)
    vim.keymap.set("n", "<leader>fd", builtin.diagnostics)
    vim.keymap.set("n", "gd", builtin.lsp_definitions)
    vim.keymap.set("n", "gr", builtin.lsp_references)
  end,
}
