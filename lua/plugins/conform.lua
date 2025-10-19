return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require "conform"

    conform.setup {
      formatters_by_ft = {
        lua = { "stylua" },
        swift = { "swiftformat_ext" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      log_level = vim.log.levels.ERROR,
      formatters = {
        swiftformat_ext = {
          command = "swiftformat",
          args = { "--stdinpath", "$FILENAME" },
        },
      },
    }

    vim.keymap.set("n", "<leader>=", function()
      conform.format {
        lsp_fallback = false,
        async = false,
        timeout_ms = 500,
      }
    end, { desc = "Format file" })
  end,
}
