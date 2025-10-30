vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  callback = function()
    vim.pack.add {
      "https://github.com/rcarriga/nvim-dap-ui",
      "https://github.com/mfussenegger/nvim-dap",
      "https://github.com/nvim-neotest/nvim-nio",
    }

    local dapui = require "dapui"

    dapui.setup {
      controls = {
        element = "console",
        enabled = true,
        icons = {
          disconnect = "",
          run_last = "",
          terminate = "⏹︎",
          pause = "⏸︎",
          play = "",
          step_into = "󰆹",
          step_out = "󰆸",
          step_over = "",
          step_back = "",
        },
      },
      floating = {
        border = "single",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      icons = {
        collapsed = "",
        expanded = "",
        current_frame = "",
      },
      layouts = {
        {
          elements = {
            -- { id = "stacks", size = 0.25 },
            -- { id = "scopes", size = 0.25 },
            -- { id = "breakpoints", size = 0.25 },
            -- { id = "watches", size = 0.25 },
          },
          position = "right",
          size = 0,
        },
        {
          elements = {
            -- { id = "repl", size = 0.4 },
            { id = "console", size = 0.6 },
          },
          position = "bottom",
          size = 10,
        },
      },
    }

    local dap = require "dap"

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    vim.keymap.set({ "n", "v" }, "<leader>du", dapui.toggle, { desc = "Toogle UI" })
  end,
})
