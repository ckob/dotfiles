return {
  "ckob/lazydotnet.nvim",
  -- main = "lazydotnet",
  -- dir = "~/repos/personal/lazydotnet.nvim",
  ---@module "lazydotnet"
  ---@type lazydotnet.Config
  opts = {
    -- cmd = { "dotnet", vim.env.HOME .. "/repos/personal/lazydotnet/src/bin/Debug/net10.0/lazydotnet.dll" },
    window = {
      width_ratio = 0.8,
      height_ratio = 0.8,
      border = "single",
    },
  },
  cmd = "LazyDotnet",
  init = function()
    vim.keymap.set({ "n", "t" }, "<C-.>", "<Cmd>LazyDotnet<CR>", { desc = "Toggle LazyDotnet" })
  end,
}
