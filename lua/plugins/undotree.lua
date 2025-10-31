vim.keymap.set("n", "<leader>u", function()
  vim.cmd "packadd nvim.undotree"

  require("undotree").open {
    command = "botright 40vnew",
  }
end, { desc = "Toggle UndoTree" })
