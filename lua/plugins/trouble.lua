return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>" },
  },

  opts = {},
  config = function()
    require("trouble").setup({
      auto_open = false,
      auto_close = false,
      auto_preview = false,
      auto_jump = false,
      mode = "quickfix",
      severity = vim.diagnostic.severity.ERROR,
      cycle_results = false,
    })
  end,
}
