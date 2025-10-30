vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  once = true,
  callback = function()
    vim.pack.add {
      "https://github.com/folke/trouble.nvim",
      "https://github.com/nvim-tree/nvim-web-devicons",
    }

    require("trouble").setup {
      auto_open = false,
      auto_close = false,
      auto_preview = false,
      auto_jump = false,
      mode = "quickfix",
      severity = vim.diagnostic.severity.ERROR,
      cycle_results = false,
    }
  end,
})

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", {
  desc = "Toggle Trouble Diagnostics",
})
