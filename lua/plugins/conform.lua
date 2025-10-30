vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  once = true,
  callback = function()
    vim.pack.add { "https://github.com/stevearc/conform.nvim" }

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

    vim.keymap.set("n", "<leader>=", conform.format, { desc = "Format file" })
  end,
})
