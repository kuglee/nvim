vim.pack.add { "https://github.com/tpope/vim-fugitive" }

vim.api.nvim_create_autocmd("FileType", {
  pattern = "fugitive",
  callback = function()
    vim.cmd "resize 15"
    vim.opt_local.winfixheight = true
  end,
})
