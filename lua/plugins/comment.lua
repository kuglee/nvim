return {
  "numToStr/Comment.nvim",
  lazy = false,
  config = function()
    require("Comment").setup {
      ---Add a space b/w comment and the line
      padding = true,
      ---Whether the cursor should stay at its position
      sticky = true,
      ---LHS of toggle mappings in NORMAL mode
      toggler = {
        line = "<leader>cc",
      },
      ---LHS of operator-pending mappings in NORMAL and VISUAL mode
      opleader = {
        line = "<leader>cc",
      },
    }
  end,
}
