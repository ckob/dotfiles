return {
  {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
    config = function()
      local dotnet = require("easy-dotnet")
      dotnet.setup({
        lsp = {
          enabled = true, -- Enable builtin roslyn lsp
          preload_roslyn = true, -- Start loading roslyn before any buffer is opened
          roslynator_enabled = true, -- Automatically enable roslynator analyzer
          easy_dotnet_analyzer_enabled = true, -- Enable roslyn analyzer from easy-dotnet-server
          auto_refresh_codelens = true,
          analyzer_assemblies = {
            vim.fn.expand('~') .. "/.dotnet-analyzers/sonaranalyzer.csharp/analyzers/SonarAnalyzer.CSharp.dll"
          },
          config = {},
        },
        auto_bootstrap_namespace = {
          --block_scoped, file_scoped
          type = "file_scoped",
          enabled = true,
        }
      })
    end,
  },
  -- {
  --   "GustavEikaas/easy-dotnet.nvim",
  --   -- branch = "feat/roslyn-lsp",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   event = "VeryLazy",
  --   config = function()
  --     local dotnet = require("easy-dotnet")
  --
  --     dotnet.setup({
  --       lsp = {
  --         enabled = true,
  --         analyzer_assemblies = {
  --           vim.fn.expand('~') .. "/.dotnet-analyzers/sonaranalyzer.csharp/analyzers/SonarAnalyzer.CSharp.dll"
  --         },
  --         roslynator_enabled = true,
  --       },
  --       test_runner = {
  --         ---@type "split" | "float" | "buf"
  --         viewmode = "split",
  --         mappings = {
  --           run_test_from_buffer = { lhs = "<leader>tt", desc = "run test from buffer" },
  --           filter_failed_tests = { lhs = "<leader>fe", desc = "filter failed tests" },
  --           debug_test = { lhs = "<leader>td", desc = "debug test" },
  --           go_to_file = { lhs = "gf", desc = "go to file" },
  --           run_all = { lhs = "<leader>tT", desc = "run all tests" },
  --           run = { lhs = "<leader>tt", desc = "run test" },
  --           peek_stacktrace = { lhs = "<leader>p", desc = "peek stacktrace of failed test" },
  --           expand = { lhs = "za", desc = "expand" },
  --           expand_node = { lhs = "zA", desc = "expand node" },
  --           expand_all = { lhs = "zR", desc = "expand all" },
  --           collapse_all = { lhs = "zM", desc = "collapse all" },
  --           close = { lhs = "q", desc = "close testrunner" },
  --           refresh_testrunner = { lhs = "<C-r>", desc = "refresh testrunner" },
  --         },
  --         -- mappings = {}
  --       },
  --       auto_bootstrap_namespace = {
  --         --block_scoped, file_scoped
  --         type = "file_scoped",
  --         enabled = true,
  --       }
  --     })
  --
  --     -- vim.keymap.set({ "n", "v" }, "<leader>.", "", { desc = "+Dotnet" })
  --     vim.keymap.set({ "n", "v" }, "<leader>..", "<cmd>Dotnet<cr>", { desc = "Dotnet Actions", silent = true })
  --
  --     -- vim.keymap.set({ "n", "v" }, "<leader>.t", "", { desc = "+Dotnet Test" })
  --     vim.keymap.set({ "n", "v" }, "<leader>.tr", "<cmd>Dotnet testrunner<cr>", { desc = "Open Dotnet [T]est [R]unner", silent = true })
  --     vim.keymap.set({ "n", "v" }, "<leader>.tt", "<cmd>Dotnet test<cr>", { desc = "Dotnet [T]est picker", silent = true })
  --     vim.keymap.set({ "n", "v" }, "<leader>.td", "<cmd>Dotnet test default<cr>", { desc = "Dotnet test [D]efault", silent = true })
  --   end,
  -- },
}
