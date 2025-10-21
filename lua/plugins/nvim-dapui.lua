return {
  "rcarriga/nvim-dap-ui",
  dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  lazy = true,
  config = function()
    require("dapui").setup {
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

    local dap, dapui = require "dap", require "dapui"

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    vim.keymap.set({ "n", "v" }, "<leader>du", require("dapui").toggle, { desc = "Toogle UI" })
  end,
}
