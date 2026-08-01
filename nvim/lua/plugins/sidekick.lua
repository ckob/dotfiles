return {
  "folke/sidekick.nvim",
  enabled = true,
  opts = {
    -- add any options here
    -- cli = {
    --   mux = {
    --     backend = "zellij",
    --     enabled = true,
    --   },
    -- },
  },
  keys = {
    {
      "<C-S-j>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        require("sidekick").nes_jump_or_apply()
        -- if not require("sidekick").nes_jump_or_apply() then
        --   return "<C-S-j>" -- fallback to normal keymap
        -- end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    -- {
    --   "<c-.>",
    --   function()
    --     require("sidekick.cli").focus()
    --   end,
    --   mode = { "n", "x", "i", "t" },
    --   desc = "Sidekick Switch Focus",
    -- },
    {
      "<leader>aic",
      function()
        require("sidekick.cli").toggle({ name = "gemini", focus = true })
      end,
      desc = "Sidekick Gemini Toggle",
      mode = { "n", "v" },
    },
    {
      "<leader>aip",
      function()
        require("sidekick.cli").prompt()
      end,
      desc = "Sidekick Ask Prompt",
      mode = { "n", "v" },
    },
  },
}
