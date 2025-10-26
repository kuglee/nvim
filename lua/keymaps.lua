vim.g.mapleader = " "

-- neovim
vim.keymap.set("n", "<leader>w", vim.cmd.w, { desc = "Save changes" })
vim.keymap.set("n", "<leader>q", vim.cmd.q, { desc = "Quit window" })
vim.keymap.set("n", "<C-s>", vim.cmd.w, { desc = "Save changes" })
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select all" })
vim.keymap.set("n", "<leader>fe", "<CMD>Oil<CR>", { desc = "Switch to the file explorer" })

-- search
vim.keymap.set("n", "<esc>", vim.cmd.nohl)
vim.keymap.set("n", "/", "/\\V", { noremap = true })

-- new line in normal mode
vim.keymap.set("n", "<CR>", "o<ESC>")
vim.keymap.set("n", "<S-Enter>", "O<ESC>")

-- navigate linewraps
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk", { silent = true })
vim.keymap.set("n", "<DOWN>", "gj")
vim.keymap.set("n", "<UP>", "gk")

-- indent selection with Tab
vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("v", "<S-Tab>", "<gv")

-- join/split line
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "gJ", "mzgJ`z")
vim.keymap.set("n", "gS", function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local before = line:sub(1, col)
  local after = line:sub(col + 1)
  vim.api.nvim_set_current_line(before)
  vim.api.nvim_buf_set_lines(0, row, row, true, { after })
end, { desc = "Split line at cursor" })

-- jump between errors
vim.keymap.set("n", "cn", "<cmd>silent cc | silent cn<cr>zz", { desc = "Jump to next issue" })
vim.keymap.set("n", "cp", "<cmd>silent cc | silent cp<cr>zz", { desc = "Jump to previous issue" })

-- buffers
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Go to next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprev<CR>", { desc = "Go to previous buffer" })

-- splits management
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>ww", "<C-w><C-w>")

-- move lines
vim.keymap.set("v", "J", ":m '>+1<CR><Esc>gv", { desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR><Esc>gv", { desc = "Move selected lines up" })

-- disable left and right movements
vim.keymap.set("n", "h", "<nop>")
vim.keymap.set("n", "l", "<nop>")

vim.keymap.set("n", "Y", "mQ0y$`Q", { desc = "Select line from beginning to end" })

-- keep cursor at end of yanked/pasted text
vim.keymap.set("v", "y", "y`]")
vim.keymap.set("n", "p", "p`]")
vim.keymap.set("n", "P", "P`]")

-- visual paste without losing clipboard content
vim.keymap.set("v", "p", '"zdP`]')
vim.keymap.set("v", "P", '"zdP`]')

-- leader paste from "z register (original neovim behavior)
vim.keymap.set("n", "<leader>p", '"zp`]')
vim.keymap.set("n", "<leader>P", '"zP`]')

-- delete/change operations go to "z register (don't pollute clipboard)
for _, op in ipairs { "x", "X", "d", "D", "c", "s" } do
  vim.keymap.set({ "n", "v" }, op, '"z' .. op)
end
vim.keymap.set("n", "dd", '"zdd') -- no dd in visual mode
