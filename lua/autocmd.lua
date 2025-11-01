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

-- sync colorscheme with background
local function sync_colorscheme_with_background(dark_theme, light_theme)
  local last_background = vim.o.background

  vim.api.nvim_create_autocmd("OptionSet", {
    pattern = "background",
    callback = function()
      if vim.o.background == last_background then
        return
      end
      last_background = vim.o.background

      vim.schedule(function()
        vim.cmd.colorscheme((vim.o.background == "dark") and dark_theme or light_theme)
      end)
    end,
  })
end

sync_colorscheme_with_background("xcodedark", "github_light")
