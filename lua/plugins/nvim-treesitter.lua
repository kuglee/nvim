-- from: https://www.reddit.com/r/neovim/comments/1ou68ds/nvimtreesitter_main_rewrite_did_i_do_this_right

vim.pack.add {
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
}

local ts = require "nvim-treesitter"
local augroup = vim.api.nvim_create_augroup("config.treesitter", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "*",
  callback = function(event)
    local filetype = event.match
    local lang = vim.treesitter.language.get_lang(filetype)

    if not lang then
      return
    end

    local is_installed = vim.treesitter.language.add(lang)

    if not is_installed then
      local available_langs = ts.get_available()
      local is_available = vim.tbl_contains(available_langs, lang)

      if is_available then
        vim.notify("Installing Tree-sitter parser for " .. lang .. "...", vim.log.levels.INFO)
        vim.schedule(function()
          ts.install { lang }
        end)
      else
        return
      end
    end

    local ok = pcall(vim.treesitter.start, event.buf, lang)
    if not ok then
      return
    end

    vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end,
})

vim.api.nvim_create_autocmd("PackChanged", {
  group = augroup,
  pattern = { "nvim-treesitter" },
  callback = function(_)
    vim.notify("Updating treesitter parsers...", vim.log.levels.INFO)
    vim.schedule(function()
      ts.update(nil, { summary = true })
    end)
  end,
})
