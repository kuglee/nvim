-- update quickfix list to make jumping between diagnostics work
vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function()
    vim.diagnostic.setqflist { open = false }
  end,
})

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("weeheavy-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank {
      higroup = "IncSearch",
      timeout = 100,
    }
  end,
})

-- clear last command message
vim.api.nvim_create_autocmd("CmdlineLeave", {
  pattern = "*",
  callback = function()
    vim.defer_fn(function()
      if vim.api.nvim_get_mode().mode ~= "c" then
        vim.api.nvim_echo({ { "" } }, false, {})
      end
    end, 5000)
  end,
})
