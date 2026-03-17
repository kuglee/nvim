vim.pack.add {
  { src = "https://github.com/nvim-neotest/neotest" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },
  { src = "https://github.com/stevanfreeborn/neotest-playwright", version = "fork"}, 
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
}

local neotest_ns = vim.api.nvim_create_namespace("neotest")

vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
      return message
    end,
  },
}, neotest_ns)


local neotest = require("neotest")

neotest.setup({
  log_level = vim.log.levels.DEBUG,
  summary = {
    follow = false,
  },

  adapters = {
    require("neotest-playwright").adapter({
      options = {
        persist_project_selection = true,
        enable_dynamic_test_discovery = false,
        preset = "headed",
        experimental = {
          telescope = {
            enabled = true,
          },
        },
      },
    }),
  },
})

vim.keymap.set("n", "<leader>tr", neotest.run.run, { desc = "Run nearest test" })

vim.keymap.set("n", "<leader>td", function()
  neotest.run.run({ strategy = "dap" })
end, { desc = "Debug nearest test" })

vim.keymap.set("n", "<leader>ts", neotest.run.stop, { desc = "Stop nearest test" })

-- vim.keymap.set("n", "<leader>tf", function()
--   neotest.run.run(vim.fn.expand("%"))
-- end, { desc = "Run file tests" })
vim.keymap.set("n", "<leader>tf", function()
  -- Move cursor to the describe block line and run that
  vim.cmd("normal! gg")  -- Go to top
  vim.cmd("/test.describe")  -- Find the describe
  neotest.run.run()  -- Run from there
end, { desc = "Run all tests in file" })


vim.keymap.set("n", "<leader>to", neotest.output.open, { desc = "Display output" })
vim.keymap.set("n", "<leader>top", neotest.output_panel.open, { desc = "Display output panel" })
vim.keymap.set("n", "<leader>topc", neotest.output_panel.clear, { desc = "Clear output" })
vim.keymap.set("n", "<C-t>", neotest.summary.open, { desc = "Display summary" })
vim.keymap.set("n", "<leader>tsr", neotest.summary.run_marked, { desc = "Run marked tests" })
vim.keymap.set("n", "<leader>tsc", neotest.summary.clear_marked, { desc = "Clear marked tests" })
vim.keymap.set("n", "<leader>tw", neotest.watch.watch, { desc = "Start watching tests" })
vim.keymap.set("n", "<leader>twc", neotest.watch.stop, { desc = "Stop watching tests" })

