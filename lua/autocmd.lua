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
local function clear_last_command_message()
  if vim.api.nvim_get_mode().mode ~= "c" then
    vim.api.nvim_echo({ { "" } }, false, {})
  end
end

vim.api.nvim_create_autocmd("CmdlineLeave", {
  pattern = "*",
  callback = function()
    vim.defer_fn(clear_last_command_message, 5000)
  end,
})
