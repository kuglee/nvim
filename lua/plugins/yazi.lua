vim.pack.add {
  "https://github.com/mikavilpas/yazi.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
}

vim.g.loaded_netrwPlugin = 1
vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    require("yazi").setup {
      open_for_directories = true,
      highlight_hovered_buffers_in_same_directory = false,
    }
  end,
})

vim.keymap.set("n", "<leader>fe", "<cmd>Yazi<cr>", { desc = "Switch to the file explorer" })
