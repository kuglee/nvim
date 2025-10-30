vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  once = true,
  callback = function()
    vim.pack.add { "https://github.com/lukas-reineke/indent-blankline.nvim" }
    require("ibl").setup()
  end,
})
