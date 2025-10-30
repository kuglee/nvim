vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  once = true,
  callback = function()
    vim.pack.add {
      "https://github.com/saghen/blink.cmp",
      "https://github.com/nvim-mini/mini.icons",
    }

    require("mini.icons").setup()
    require("blink.cmp").setup {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        preset = "enter",
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<Tab>"] = { "accept", "fallback" },
        ["<C-c>"] = { "cancel", "fallback" },
        ["<C-j>"] = { "scroll_documentation_down" },
        ["<C-k>"] = { "scroll_documentation_up" },
        ["<S-Enter>"] = {
          function(cmp)
            if not cmp.is_visible() then
              return false -- Run fallback
            end
            cmp.select_next { auto_insert = true, count = 0 }
            cmp.hide()
            return true
          end,
          "fallback",
        },
      },
      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },
      completion = {
        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
        documentation = { auto_show = true },
        menu = {
          draw = {
            components = {
              kind_icon = {
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
                -- (optional) use highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
              kind = {
                -- (optional) use highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
            },
          },
        },
      },
      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lsp", "path", "snippets" },
        providers = {
          git = {
            module = "blink-cmp-git",
            name = "Git",
            -- only enable this source when filetype is gitcommit, markdown, or 'octo'
            enabled = function()
              return vim.tbl_contains({ "octo", "gitcommit", "markdown" }, vim.bo.filetype)
            end,
            opts = {
              -- options for the blink-cmp-git
            },
          },
        },
        per_filetype = {
          lua = { "lsp", "buffer", "path", "snippets" },
          markdown = { "lsp", "path", "snippets" }, -- do not add 'buffer' here, it's slow AF
          text = { "buffer", "path" },
          swift = { "lsp", "buffer", "path" },
        },
      },
      fuzzy = { implementation = "lua" },
    }
  end,
})
