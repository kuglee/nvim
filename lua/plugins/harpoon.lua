vim.pack.add {
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
}

local harpoon = require "harpoon"

harpoon:setup()

vim.keymap.set("n", "<leader>a", function()
  harpoon:list():add()
end)
vim.keymap.set("n", "<leader>e", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<leader>h", function()
  harpoon:list():select(1)
end)
vim.keymap.set("n", "<leader>j", function()
  harpoon:list():select(2)
end)
vim.keymap.set("n", "<leader>k", function()
  harpoon:list():select(3)
end)
vim.keymap.set("n", "<leader>l", function()
  harpoon:list():select(4)
end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function()
  harpoon:list():prev()
end)
vim.keymap.set("n", "<C-S-N>", function()
  harpoon:list():next()
end)

harpoon:extend {
  UI_CREATE = function(cx)
    vim.keymap.set("n", "<C-v>", function()
      harpoon.ui:select_menu_item { vsplit = true }
    end, { buffer = cx.bufnr })

    vim.keymap.set("n", "<C-x>", function()
      harpoon.ui:select_menu_item { split = true }
    end, { buffer = cx.bufnr })
  end,
}

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Harpoon",
      finder = require("telescope.finders").new_table {
        results = file_paths,
      },
      previewer = conf.file_previewer {},
      sorter = conf.generic_sorter {},
    })
    :find()
end

vim.keymap.set("n", "<leader>fh", function()
  toggle_telescope(harpoon:list())
end, { desc = "Open harpoon window" })
