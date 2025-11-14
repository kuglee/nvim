vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  once = true,
  callback = function()
    vim.pack.add { "https://github.com/mfussenegger/nvim-dap" }

    local dap = require "dap"
    local areSet = false

    dap.listeners.after["event_initialized"]["me"] = function()
      if not areSet then
        areSet = true
        vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue", noremap = true })
        vim.keymap.set("n", "<leader>dC", dap.run_to_cursor, { desc = "Run To Cursor" })
        vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "Step Over" })
        vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
        vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step Out" })
        vim.keymap.set(
          { "n", "v" },
          "<Leader>dh",
          require("dap.ui.widgets").hover,
          { desc = "Hover" }
        )
        vim.keymap.set({ "n", "v" }, "<Leader>de", require("dapui").eval, { desc = "Eval" })
      end
    end

    dap.listeners.after["event_terminated"]["me"] = function()
      if areSet then
        areSet = false
        vim.keymap.del("n", "<leader>dc")
        vim.keymap.del("n", "<leader>dC")
        vim.keymap.del("n", "<leader>ds")
        vim.keymap.del("n", "<leader>di")
        vim.keymap.del("n", "<leader>do")
        vim.keymap.del({ "n", "v" }, "<Leader>dh")
        vim.keymap.del({ "n", "v" }, "<Leader>de")
      end
    end

    --when breakpoint is hit, it sets the focus to the buffer with the breakpoint
    dap.defaults.fallback.switchbuf = "usetab,uselast"
  end,
})
