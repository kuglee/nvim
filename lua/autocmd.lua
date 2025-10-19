-- remove padding around neovim instance
vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
  callback = function()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    if not normal.bg then
      return
    end
    io.write(string.format("\027]11;#%06x\027\\", normal.bg))
  end,
})
vim.api.nvim_create_autocmd("UILeave", {
  callback = function()
    io.write "\027]111\027\\"
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

-- hide last command
function Empty_message()
  if vim.api.nvim_get_mode().mode ~= "c" then
    vim.api.nvim_echo({ { "" } }, false, {})
  end
end
vim.cmd [[autocmd CmdlineLeave * lua vim.defer_fn(Empty_message, 5000)]]

-- auto change theme
-- doesn't work in Ghostty
vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "background",
  callback = function()
    if vim.o.background == "dark" then
      vim.cmd "colorscheme xcodedark"
    else
      vim.cmd "colorscheme github_light"
    end
  end,
})
