vim.diagnostic.config { virtual_text = true }

local autogroup = vim.api.nvim_create_augroup("my.diagnostic", {})

-- Shows the diagnostic window at the start of the virtual text
-- TODO: hide virtual_text for the current line
vim.api.nvim_create_autocmd("CursorHold", {
  group = autogroup,
  callback = function()
    local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line "." - 1 })
    if #diagnostics > 0 then
      local _, winnr = vim.diagnostic.open_float(nil, {
        focus = false,
        border = { "", "", "", " ", "", "", "", " " },
      })

      if winnr and vim.api.nvim_win_is_valid(winnr) then
        local cursor_col = vim.fn.col "."
        local line_end = vim.fn.col "$"
        local virtual_text_offset = 5 -- FIXME: get the actual offset
        local offset = line_end - cursor_col + virtual_text_offset

        vim.api.nvim_win_set_config(winnr, {
          relative = "cursor",
          row = 0,
          col = offset,
          anchor = "NW",
        })
      end
    end
  end,
})
