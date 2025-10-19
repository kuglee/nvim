return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
  config = function()
    require("tiny-inline-diagnostic").setup {
      options = {
        multiple_diag_under_cursor = true,
        add_messages = true,
        show_all_diags_on_cursorline = true,
        multilines = {
          enabled = true,
          always_show = true,
          trim_whitespaces = false,
          tabstop = 4,
        },
      },
    }
    vim.diagnostic.config { virtual_text = false } -- Disable default virtual text
  end,
}
