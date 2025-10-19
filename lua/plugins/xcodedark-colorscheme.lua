return {
  "V4N1LLA-1CE/xcodedark.nvim",
  config = function()
    require("xcodedark").setup {
      styles = {
        keywords = { bold = true },
        comments = { italic = true },
      },
    }

    vim.cmd.colorscheme "xcodedark"
    vim.opt.guicursor:append "a:blinkon0"
  end,
}
