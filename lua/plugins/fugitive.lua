vim.pack.add { "https://github.com/tpope/vim-fugitive" }

vim.api.nvim_create_autocmd("FileType", {
  pattern = "fugitive",
  callback = function()
    vim.cmd "resize 15"
    vim.opt_local.winfixheight = true
  end,
})

local function toggle_fugitive()
  local fugitive_buf
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].filetype == "fugitive" then
      fugitive_buf = buf
      break
    end
  end

  if fugitive_buf then
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == fugitive_buf then
        vim.api.nvim_win_close(win, false)
        return
      end
    end
    vim.api.nvim_buf_delete(fugitive_buf, { force = true })
  else
    vim.cmd "Git"
  end
end

vim.keymap.set("n", "<leader>gs", toggle_fugitive, { desc = "Toggle Fugitive status" })
