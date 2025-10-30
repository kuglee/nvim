vim.keymap.set("n", "<leader>u", function()
  if not package.loaded["undotree"] then
    vim.pack.add {
      "https://github.com/jiaoshijie/undotree",
      "https://github.com/nvim-lua/plenary.nvim",
    }
  end

  require("undotree").toggle()
end, { desc = "Toggle UndoTree" })
