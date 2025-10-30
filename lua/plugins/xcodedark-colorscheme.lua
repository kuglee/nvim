vim.pack.add { "https://github.com/V4N1LLA-1CE/xcodedark.nvim" }

require("xcodedark").setup {
  styles = {
    keywords = { bold = true },
    comments = { italic = true },
  },
}

local function apply_custom_styles()
  vim.opt.guicursor:append "a:blinkon0"
  vim.api.nvim_set_hl(0, "TelescopePreviewLine", { bg = "#636f83", bold = true })
end

apply_custom_styles()

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "xcodedark",
  callback = apply_custom_styles,
})
