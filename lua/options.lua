-- split windows
vim.opt.splitbelow = true -- horizontal split below current
vim.opt.splitright = true -- vertical split to right of current

-- line numbers
vim.opt.number = true -- show line numbers
vim.opt.relativenumber = true -- use relative line numbers
vim.opt.scrolloff = 10 -- show next n lines while scrolling

-- cursor line
vim.opt.cursorline = true -- highlight the current cursor line

-- tabs & indentation
vim.opt.virtualedit = "onemore" -- allow for cursor beyond last character
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.smarttab = true -- be smart when using tabs
vim.opt.tabstop = 2 -- tab length in spaces
vim.opt.shiftwidth = 2 -- tab length in spaces
vim.opt.autoindent = true -- copy indent from current line when starting a new line
vim.opt.smartindent = true -- smart autoindenting when starting a new line
vim.opt.list = true -- helper for indent mistake
vim.opt.listchars = { tab = "»·", trail = "·" }

-- line wrapping
vim.opt.linebreak = true -- don't break words when wrapping lines

-- search settings
vim.opt.ignorecase = true -- make searching case insensitive
vim.opt.smartcase = true -- when searching try to be smart about cases
vim.opt.hlsearch = true -- highlight search results
vim.opt.incsearch = true -- highlight all matches while incremental searching
vim.opt.inccommand = "split" -- show search preview window

-- clipboard
vim.opt.clipboard:append "unnamedplus" -- use system clipboard as default register

-- swapfile & backup & undo
vim.opt.swapfile = false -- no swap files
vim.opt.backup = false -- no backup files
vim.opt.writebackup = false -- nnly in case you don"t want a backup file while editing
vim.opt.undodir = os.getenv "HOME" .. "/.vim/undodir"
vim.opt.undofile = true

-- appearance
vim.opt.termguicolors = true -- enable colors for terminal
vim.opt.title = true -- display the current filename in the termial window title
vim.opt.signcolumn = "yes" -- always show signcolumn
vim.opt.showmatch = true -- show matching brackets
vim.opt.showmode = false -- don't show editing mode
vim.opt.showcmd = false -- don't show last (partial) command
vim.opt.updatetime = 50

-- commenting
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove { "c", "r", "o" }
  end,
})

-- better diffs
vim.opt.diffopt:append "algorithm:histogram"

-- LSP activation (references lsp/<filename>)
vim.lsp.enable {
  "luals",
  "sourcekit-lsp",
}
