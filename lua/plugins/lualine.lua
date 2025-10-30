vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.pack.add {
      "https://github.com/nvim-lualine/lualine.nvim",
      "https://github.com/nvim-tree/nvim-web-devicons",
    }

    local function visual_selection_info()
      local mode = vim.fn.mode()
      if mode == "v" or mode == "V" or mode == "\22" then
        local start_line = vim.fn.line "v"
        local start_col = vim.fn.col "v"
        local end_line = vim.fn.line "."
        local end_col = vim.fn.col "."

        -- Normalize selection rectangle
        local s_line = math.min(start_line, end_line)
        local e_line = math.max(start_line, end_line)
        local s_col = math.min(start_col, end_col)
        local e_col = math.max(start_col, end_col)

        local lines = e_line - s_line + 1
        local chars = 0

        if mode == "V" then
          chars = 0
        elseif mode == "v" then
          if lines == 1 then
            chars = e_col - s_col + 1
          else
            local count = 0
            for l = s_line, e_line do
              local line_len = #vim.fn.getline(l)
              if l == s_line then
                count = count + line_len - s_col + 2
              elseif l == e_line then
                count = count + e_col
              else
                count = count + line_len + 1
              end
            end
            chars = count
          end
        elseif mode == "\22" then -- visual block
          local width = e_col - s_col + 1
          chars = width * lines
        end

        if chars == 0 then
          return string.format("%dL", lines)
        else
          return string.format("%dL,%dC", lines, chars)
        end
      end
      return ""
    end

    require("lualine").setup {
      options = {
        globalstatus = true,
        theme = "auto",
        symbols = {
          alternate_file = "#",
          directory = "",
          readonly = "",
          unnamed = "[No Name]",
          newfile = "[New]",
        },
        disabled_buftypes = { "quickfix", "prompt" },
        component_separators = "",
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = {
          -- { "mode" },
          { "filename" },
        },
        lualine_b = {
          { "diagnostics" },
          { "diff" },
          {
            "searchcount",
            maxcount = 999,
            timeout = 500,
          },
        },
        lualine_c = {},
        lualine_x = {
          { "'󰙨 ' .. vim.g.xcodebuild_test_plan", color = { fg = "#a6e3a1", bg = "#161622" } },
          {
            "vim.g.xcodebuild_platform == 'macOS' and '  macOS' or"
              .. " ' ' .. vim.g.xcodebuild_device_name .. ' (' .. vim.g.xcodebuild_os .. ')'",
            color = { fg = "#f9e2af", bg = "#161622" },
          },
        },
        lualine_y = {
          { "branch" },
        },
        lualine_z = {
          visual_selection_info,
          "location",
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "nvim-dap-ui", "quickfix", "trouble", "nvim-tree", "lazy", "mason" },
    }
  end,
})
