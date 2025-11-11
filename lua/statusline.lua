-- Copyright (c) 2020-2021 shadmansaleh
-- MIT license, see LICENSE for more details.

local auto_theme = {}

-- Note for now only works for termguicolors scope can be bg or fg or any other
-- attr parameter like bold/italic/reverse
---@param color_group string hl_group name
---@param scope       string? bg | fg | sp
---@return table|string|nil returns #rrggbb formatted color when scope is specified
----                       or complete color table when scope isn't specified
function auto_theme.extract_highlight_colors(color_group, scope)
  if vim.fn.hlexists(color_group) == 0 then
    return nil
  end

  local hl = vim.api.nvim_get_hl(0, { name = color_group })

  local color = {}

  if hl.bg then
    color.bg = string.format("#%06x", hl.bg)
  end

  if hl.fg then
    color.fg = string.format("#%06x", hl.fg)
  end

  if hl.sp then
    color.sp = string.format("#%06x", hl.sp)
  end

  -- preserve the reverse attribute
  color.reverse = hl.reverse

  if scope then
    return color[scope]
  end

  return color
end

--- retrieves color value from highlight group name in syntax_list
--- first present highlight is returned
---@param scope string|string[]
---@param syntaxlist string[]
---@param default string
---@return string|nil
function auto_theme.extract_color_from_hllist(scope, syntaxlist, default)
  local scope_list = type(scope) == "table" and scope or { scope }

  for _, highlight_name in ipairs(syntaxlist) do
    if vim.fn.hlexists(highlight_name) ~= 0 then
      local color = auto_theme.extract_highlight_colors(highlight_name)

      if color then
        for _, sc in ipairs(scope_list) do
          if color.reverse then
            if sc == "bg" then
              sc = "fg"
            elseif sc == "fg" then
              sc = "bg"
            end
          end

          if color[sc] then
            return color[sc]
          end
        end
      end
    end
  end

  return default
end

---------------
-- Constants --
---------------
-- fg and bg must have this much contrast range 0 < contrast_threshold < 0.5
auto_theme.contrast_threshold = 0.3
-- how much brightness is changed in percentage for light and dark themes
auto_theme.brightness_modifier_parameter = 10

-- Turns #rrggbb -> { red, green, blue }
function auto_theme.rgb_str2num(rgb_color_str)
  if rgb_color_str:find "#" == 1 then
    rgb_color_str = rgb_color_str:sub(2, #rgb_color_str)
  end
  local red = tonumber(rgb_color_str:sub(1, 2), 16)
  local green = tonumber(rgb_color_str:sub(3, 4), 16)
  local blue = tonumber(rgb_color_str:sub(5, 6), 16)
  return { red = red, green = green, blue = blue }
end

-- Turns { red, green, blue } -> #rrggbb
function auto_theme.rgb_num2str(rgb_color_num)
  local rgb_color_str =
    string.format("#%02x%02x%02x", rgb_color_num.red, rgb_color_num.green, rgb_color_num.blue)
  return rgb_color_str
end

-- Returns brightness level of color in range 0 to 1
-- arbitrary value it's basically an weighted average
function auto_theme.get_color_brightness(rgb_color)
  local color = auto_theme.rgb_str2num(rgb_color)
  local brightness = (color.red * 2 + color.green * 3 + color.blue) / 6
  return brightness / 256
end

-- returns average of colors in range 0 to 1
-- used to determine contrast level
function auto_theme.get_color_avg(rgb_color)
  local color = auto_theme.rgb_str2num(rgb_color)
  return (color.red + color.green + color.blue) / 3 / 256
end

-- Clamps the val between left and right
local function clamp(val, left, right)
  if val > right then
    return right
  end
  if val < left then
    return left
  end
  return val
end

-- Changes brightness of rgb_color by percentage
function auto_theme.brightness_modifier(rgb_color, percentage)
  local color = auto_theme.rgb_str2num(rgb_color)
  color.red = clamp(color.red + (color.red * percentage / 100), 0, 255)
  color.green = clamp(color.green + (color.green * percentage / 100), 0, 255)
  color.blue = clamp(color.blue + (color.blue * percentage / 100), 0, 255)
  return auto_theme.rgb_num2str(color)
end

-- Changes contrast of rgb_color by amount
function auto_theme.contrast_modifier(rgb_color, amount)
  local color = auto_theme.rgb_str2num(rgb_color)
  color.red = clamp(color.red + amount, 0, 255)
  color.green = clamp(color.green + amount, 0, 255)
  color.blue = clamp(color.blue + amount, 0, 255)
  return auto_theme.rgb_num2str(color)
end

-- Changes brightness of foreground color to achieve contrast
-- without changing the color
function auto_theme.apply_contrast(highlight)
  local highlight_bg_avg = auto_theme.get_color_avg(highlight.bg)
  local contrast_threshold_config = clamp(auto_theme.contrast_threshold, 0, 0.5)
  local contrast_change_step = 5
  if highlight_bg_avg > 0.5 then
    contrast_change_step = -contrast_change_step
  end

  -- Don't waste too much time here max 25 iteration should be more than enough
  local iteration_count = 1
  while
    math.abs(auto_theme.get_color_avg(highlight.fg) - highlight_bg_avg)
      < contrast_threshold_config
    and iteration_count < 25
  do
    highlight.fg = auto_theme.contrast_modifier(highlight.fg, contrast_change_step)
    iteration_count = iteration_count + 1
  end
end

function auto_theme.get_lualine_auto_colors()
  -- Get the colors to create theme
  local colors = {
    normal = auto_theme.extract_color_from_hllist(
      "bg",
      { "PmenuSel", "PmenuThumb", "TabLineSel" },
      "#000000"
    ),
    back1 = auto_theme.extract_color_from_hllist("bg", { "Normal", "StatusLineNC" }, "#000000"),
    fore = auto_theme.extract_color_from_hllist("fg", { "Normal", "StatusLine" }, "#000000"),
    back2 = auto_theme.extract_color_from_hllist("bg", { "StatusLine" }, "#000000"),
  }

  -- Change brightness of colors
  -- Darken if light theme (or) Lighten if dark theme
  local normal_color = auto_theme.extract_highlight_colors("Normal", "bg")
  if normal_color ~= nil then
    if auto_theme.get_color_brightness(normal_color) > 0.5 then
      auto_theme.brightness_modifier_parameter = -auto_theme.brightness_modifier_parameter
    end
    for name, color in pairs(colors) do
      colors[name] = auto_theme.brightness_modifier(color, auto_theme.brightness_modifier_parameter)
    end
  end

  -- Basic theme definition
  local M = {
    a = { bg = colors.normal, fg = colors.back1, gui = "bold" },
    b = { bg = colors.back1, fg = colors.normal },
    c = { bg = colors.back2, fg = colors.fore },
  }

  -- Apply proper contrast so text is readable
  for _, highlight in pairs(M) do
    auto_theme.apply_contrast(highlight)
  end

  return M
end

local function get_lualine_colors()
  local colors_name = vim.g.colors_name

  if colors_name and colors_name ~= "" then
    local ok, theme = pcall(require, "lualine.themes." .. colors_name)
    if ok then
      return theme.normal
    end
  end

  return auto_theme.get_lualine_auto_colors()
end

Statusline = {}

local function setup_colors()
  local colors = get_lualine_colors()

  vim.api.nvim_set_hl(0, "LualineA", { fg = colors.a.fg, bg = colors.a.bg, bold = true })
  vim.api.nvim_set_hl(0, "LualineB", { fg = colors.b.fg, bg = colors.b.bg })
  vim.api.nvim_set_hl(0, "LualineC", { fg = colors.c.fg, bg = colors.c.bg })
  vim.api.nvim_set_hl(0, "XcodebuildTestPlan", { fg = "#a6e3a1", bg = "#161622" })
  vim.api.nvim_set_hl(0, "XcodebuildDevice", { fg = "#f9e2af", bg = "#161622" })
end

setup_colors()

local function diagnostic_info(current_hl)
  local diag_error_fg = vim.api.nvim_get_hl(0, { name = "DiagnosticError" }).fg or "#FF0000"
  local diag_warn_fg = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn" }).fg or "#FFFF00"
  local diag_info_fg = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo" }).fg or "#0000FF"

  vim.api.nvim_set_hl(
    0,
    "StatuslineDiagnosticError",
    vim.tbl_extend("force", vim.api.nvim_get_hl(0, { name = current_hl }), { fg = diag_error_fg })
  )
  vim.api.nvim_set_hl(
    0,
    "StatuslineDiagnosticWarn",
    vim.tbl_extend("force", vim.api.nvim_get_hl(0, { name = current_hl }), { fg = diag_warn_fg })
  )
  vim.api.nvim_set_hl(
    0,
    "StatuslineDiagnosticInfo",
    vim.tbl_extend("force", vim.api.nvim_get_hl(0, { name = current_hl }), { fg = diag_info_fg })
  )

  local icons = {
    Error = "%#StatuslineDiagnosticError# 􀒊 ",
    Warn = "%#StatuslineDiagnosticWarn# 􀇿 ",
    Hint = "%#StatuslineDiagnosticWarn# 􀛮 ",
    Info = "%#StatuslineDiagnosticInfo# 􀅵 ",
  }

  local parts = {}
  for severity, icon in pairs(icons) do
    local n = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[string.upper(severity)] })
    if n > 0 then
      table.insert(parts, icon .. " " .. n)
    end
  end

  return #parts > 0 and table.concat(parts, " ") .. " " or ""
end

local file = " %<%f %h%w%m%r "
local ruler = " %{% &ruler ? ( &rulerformat == '' ? '%-14.(%l,%c%V%) %P' : &rulerformat ) : '' %} "
local git_branch = " 􀙡 %{fugitive#Head()} "
local xcodebuild_test =
  "%#XcodebuildTestPlan#%{get(g:, 'xcodebuild_test_plan', '') != '' ? ' 􁁛  ' . get(g:, 'xcodebuild_test_plan', '') . ' ' : ''}%*"
local xcodebuild =
  "%#XcodebuildDevice#%{get(g:, 'xcodebuild_platform', '') == 'macOS' ? ' 􁟫  macOS ' : (get(g:, 'xcodebuild_platform', '') != '' ? ' 􀟜 ' . get(g:, 'xcodebuild_device_name', '') . ' (' . get(g:, 'xcodebuild_os', '') . ') ' : '')}%*"

function Statusline.active()
  return table.concat {
    "%#LualineA#",
    file,
    "%*",
    "%#LualineB#",
    diagnostic_info "LualineB",
    "%*",
    "%#LualineC#",
    "%=",
    "%*",
    xcodebuild_test,
    xcodebuild,
    "%#LualineB#",
    git_branch,
    "%*",
    "%#LualineA#",
    ruler,
    "%*",
  }
end

local group = vim.api.nvim_create_augroup("Statusline", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = setup_colors,
})

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = group,
  callback = function()
    vim.opt_local.statusline = "%!v:lua.Statusline.active()"
  end,
})
