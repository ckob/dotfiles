return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {},
  config = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>b", group = "[B]uffer" },
      { "<leader>c", group = "[C]ode" },
      { "<leader>g", group = "[G]it" },
      { "<leader>f", group = "[F]ind" },
      { "<leader>e", group = "[E]xplorer" },
      { "<leader>o", group = "[O]pen" },
      { "<leader>.", group = "[.]NET" }
    })
  end,
}
