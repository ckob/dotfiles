return {
  "supermaven-inc/supermaven-nvim",
  event = "VeryLazy",
  config = function()
    require("supermaven-nvim").setup({
      keymaps = {
        -- 'f' for "full" suggestion
        accept_suggestion = "<C-S-f>",

        -- ']' is like an "abort" character
        clear_suggestion = "<C-]>",

        -- 'g' for "go" forward one word
        accept_word = "<C-g>",
      },
    })
  end,
}
