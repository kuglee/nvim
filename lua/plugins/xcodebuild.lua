local progress_handle

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  once = true,
  callback = function()
    vim.pack.add {
      "https://github.com/wojciech-kulik/xcodebuild.nvim",
      "https://github.com/nvim-telescope/telescope.nvim",
      "https://github.com/MunifTanjim/nui.nvim",
      "https://github.com/mfussenegger/nvim-dap",
    }

    require("xcodebuild").setup {
      show_build_progress_bar = true,
      logs = {
        auto_open_on_success_tests = false,
        auto_open_on_failed_tests = false,
        auto_open_on_success_build = false,
        auto_open_on_failed_build = true,
        auto_focus = false,
        auto_close_on_app_launch = true,
        only_summary = true,
        notify = function(message, severity)
          local fidget = require "fidget"
          if progress_handle then
            progress_handle.message = message
            if not message:find "Loading" then
              progress_handle:finish()
              progress_handle = nil
              if vim.trim(message) ~= "" then
                fidget.notify(message, severity)
              end
            end
          else
            fidget.notify(message, severity)
          end
        end,
        notify_progress = function(message)
          local progress = require "fidget.progress"

          if progress_handle then
            progress_handle.title = ""
            progress_handle.message = message
          else
            progress_handle = progress.handle.create {
              message = message,
              lsp_client = { name = "xcodebuild.nvim" },
            }
          end
        end,
      },
      test_explorer = {
        enabled = true,
        auto_open = true,
        auto_focus = false,
      },
      code_coverage = {
        enabled = true,
      },
    }

    -- stylua: ignore start
    vim.keymap.set("n", "<leader>X", "<cmd>XcodebuildPicker<cr>", { desc = "Show Xcodebuild Actions" })
    vim.keymap.set("n", "<leader>xf", "<cmd>XcodebuildProjectManager<cr>", { desc = "Show Project Manager Actions" })

    vim.keymap.set("n", "<leader>xb", "<cmd>XcodebuildBuild<cr>", { desc = "Build Project" })
    vim.keymap.set("n", "<leader>xB", "<cmd>XcodebuildBuildForTesting<cr>", { desc = "Build For Testing" })
    vim.keymap.set("n", "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Build & Run Project" })

    vim.keymap.set("n", "<leader>xt", "<cmd>XcodebuildTest<cr>", { desc = "Run Tests" })
    vim.keymap.set("v", "<leader>xt", "<cmd>XcodebuildTestSelected<cr>", { desc = "Run Selected Tests" })
    vim.keymap.set("n", "<leader>xT", "<cmd>XcodebuildTestClass<cr>", { desc = "Run This Test Class" })

    vim.keymap.set("n", "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Toggle Xcodebuild Logs" })
    vim.keymap.set("n", "<leader>xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", { desc = "Toggle Code Coverage" })
    vim.keymap.set("n", "<leader>xC", "<cmd>XcodebuildShowCodeCoverageReport<cr>", { desc = "Show Code Coverage Report" })
    vim.keymap.set("n", "<leader>xe", "<cmd>XcodebuildTestExplorerToggle<cr>", { desc = "Toggle Test Explorer" })
    vim.keymap.set("n", "<leader>xs", "<cmd>XcodebuildFailingSnapshots<cr>", { desc = "Show Failing Snapshots" })

    vim.keymap.set("n", "<leader>xd", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select Device" })
    vim.keymap.set("n", "<leader>xp", "<cmd>XcodebuildSelectTestPlan<cr>", { desc = "Select Test Plan" })
    vim.keymap.set("n", "<leader>xa", "<cmd>XcodebuildCancel<cr>", { desc = "Cancel currently running action" })
    -- stylua: ignore end

    -- DAP integration
    local xcodebuild = require "xcodebuild.integrations.dap"
    xcodebuild.setup()

    local define = vim.fn.sign_define
    define("DapBreakpoint", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
    define(
      "DapBreakpointRejected",
      { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" }
    )
    define("DapStopped", { text = "", texthl = "DiagnosticOk", linehl = "", numhl = "" })
    define("DapLogPoint", { text = "", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
    define("DapLogPoint", { text = "", texthl = "DiagnosticInfo", linehl = "", numhl = "" })

    --when breakpoint is hit, it sets the focus to the buffer with the breakpoint
    require("dap").defaults.fallback.switchbuf = "usetab,uselast"

    --stylua: ignore start
    vim.keymap.set("n", "<leader>dd", xcodebuild.build_and_debug, { desc = "Build & Debug" })
    vim.keymap.set("n", "<leader>dr", xcodebuild.debug_without_build, { desc = "Debug Without Building" })
    vim.keymap.set("n", "<leader>dt", xcodebuild.debug_tests, { desc = "Debug Tests" })
    vim.keymap.set("n", "<leader>dT", xcodebuild.debug_class_tests, { desc = "Debug Class Tests" })
    vim.keymap.set("n", "<leader>b", xcodebuild.toggle_breakpoint, { desc = "Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>B", xcodebuild.toggle_message_breakpoint, { desc = "Toggle Message Breakpoint" })
    --stylua: ignore end

    vim.keymap.set("n", "<leader>dx", function()
      xcodebuild.terminate_session()
      require("dap").listeners.after["event_terminated"]["me"]()
    end, { desc = "Terminate debugger" })
  end,
})
