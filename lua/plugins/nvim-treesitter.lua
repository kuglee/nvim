vim.pack.add {
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/windwp/nvim-ts-autotag",
}

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  once = true,
  callback = function()
    require("nvim-treesitter.configs").setup {
      highlight = { enable = true },
      indent = { enable = true },
      autotag = { enable = false },
      ensure_installed = {
        "json",
        "yaml",
        "markdown",
        "markdown_inline",
        "lua",
        "gitignore",
        "swift",
        "elm",
        "javascript",
        "typescript",
        "php",
      },
      auto_install = true,
    }
  end,
})
