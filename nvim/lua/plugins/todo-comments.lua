return {
  "folke/todo-comments.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/snacks.nvim",
  },
  opts = {},
  keys = {
    -- TODO: test todo message
    ---@diagnostic disable-next-line: undefined-field
    { "<leader>ft", function() require("snacks").picker.todo_comments() end, desc = "Find Todo" },

    { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
  },
}
