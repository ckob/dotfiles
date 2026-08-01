return {
  "olimorris/codecompanion.nvim",
  enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } }, -- Optional: For prettier markdown rendering
    "github/copilot.vim", -- Optional: For GitHub Copilot integration
  },
  init = function()
    -- Disable Copilot autocompletion globally because it's activated automatically when having it as dependency here
    vim.g.copilot_enabled = 0
    -- vim.g.copilot_no_tab_map = true
  end,
  opts = {
    adapters = {
      acp = {
        gemini_cli = function()
          return require("codecompanion.adapters").extend("gemini_cli", {
            defaults = {
              auth_method = "oauth-personal",
            },
          })
        end,
      },
    },
    strategies = {
      -- Change the default chat adapter
      chat = {
        adapter = "gemini_cli",
      },
      -- inline = {
      --   adapter = "gemini_cli",
      -- },
    },
    -- strategies = {
    --   -- Change the default chat adapter
    --   chat = {
    --     adapter = "gemini",
    --   },
    --   -- inline = {
    --   --   adapter = "gemini",
    --   -- },
    -- },
    -- display = {
    --   chat = {
    --     show_settings = true,
    --   },
    -- },
    -- extensions = {
    --   history = {
    --     enabled = true,
    --   },
    --   vectorcode = {
    --     opts = {
    --       add_tool = true,
    --     },
    --   },
    -- },
  },
  keys = {
    { "<leader>a", "", desc = "+AI", mode = { "n", "v" } },
    { "<leader>aic", "<cmd>CodeCompanionChat<cr>", desc = "Chat with AI", mode = "n", silent = true },
    { "<leader>ai<CR>", "<cmd>CodeCompanion<cr>", desc = "Inline AI Assist", mode = "n", silent = true },
    { "<leader>aia", "<cmd>CodeCompanionActions<cr>", desc = "[AI] [A]ctions Palette", mode = "n", silent = true },
    { "<leader>ai", ":CodeCompanion<cr>", desc = "Inline AI Assist (visual mode)", mode = "v", silent = true },
    { "<leader>aih", "<cmd>CodeCompanionHistory<cr>", desc = "History Chats", mode = "n", silent = true },
  },
}
