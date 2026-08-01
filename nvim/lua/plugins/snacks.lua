---@module 'lazy'

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    image = {},
    picker = {
      actions = {
        explorer_grep = function(picker)
          local item = picker:current()
          if not item or not item.file then return end

          local dir = vim.fn.isdirectory(item.file) == 1 and item.file
              or vim.fn.fnamemodify(item.file, ":h")

          Snacks.picker.grep({
            cwd = dir,
            title = "Grep in " .. vim.fn.fnamemodify(dir, ":t")
          })
        end,
      },
      sources = {
        explorer = {
          win = {
            input = {
              keys = {
                ["<esc>"] = { "", mode = "n" },
              },
            },
            list = {
              keys = {
                ["<esc>"] = { "", mode = "n" },
                ["<leader>fs"] = { "explorer_grep", mode = { "n", "x" }, desc = "Grep in directory" },
              },
            },
          }
        }
      }
    },
    explorer = {},
    dashboard = {},
    bufdelete = {},
    lazygit = {
      configure = true,
      config = {
        os = {
          editPreset = "nvim-remote",
          edit = 'nvim --server "$NVIM" --remote-send "<C-\\><C-n>:close<CR>:edit {{filename}}<CR>"',
          editAtLine = 'nvim --server "$NVIM" --remote-send "<C-\\><C-n>:close<CR>:edit {{filename}}<CR>:{{line}}<CR>"',
        },
      },
    },
    scratch = {},
    input = {},
    indent = {
      indent = {
        char = "┊"
      },
      animate = {
        enabled = false,
      }
    },
  },
  -- stylua: ignore
  keys = {
    -- Find
    -- { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>ff", function() Snacks.picker.files() end,              desc = "Find Files" },
    { "<leader>fs", function() Snacks.picker.grep() end,               desc = "Find String (Grep)" },
    { "<leader>fw", function() Snacks.picker.grep_word() end,          desc = "Find visual selection or word (Grep)", mode = { "n", "x" } },
    { "<leader>fr", function() Snacks.picker.recent() end,             desc = "Recent" },
    { "<leader>fk", function() Snacks.picker.keymaps() end,            desc = "Keymaps" },
    { "<leader>fb", function() Snacks.picker.buffers() end,            desc = "Buffers" },
    -- { "<leader>ft", function() Snacks.picker.todo_comments() end, desc = "Todo" },
    --
    -- Explorer
    { "<leader>ee", function() Snacks.explorer({ focus = false }) end, desc = "File Explorer" },
    {
      "<leader>ef",
      function()
        local explorer_pickers = Snacks.picker.get({ source = "explorer" })
        if #explorer_pickers == 0 then
          Snacks.explorer()
        else
          explorer_pickers[1]:focus("list")
        end
      end,
      desc = "Find files",
    },

    { "gd",         function() Snacks.picker.lsp_definitions() end,      desc = "Goto Definition" },
    { "gD",         function() Snacks.picker.lsp_declarations() end,     desc = "Goto Declaration" },
    { "gR",         function() Snacks.picker.lsp_references() end,       desc = "References",            nowait = true },
    { "gI",         function() Snacks.picker.lsp_implementations() end,  desc = "Goto Implementation" },
    { "gy",         function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },

    -- buffer
    { "<leader>bb", "<C-^>",                                             desc = "Switch to last buffer" },
    { "<leader>bd", function() Snacks.bufdelete() end,                   desc = "Delete Buffer" },
    { "<leader>bo", function() Snacks.bufdelete.other() end,             desc = "Delete Other Buffers" },

    { "<leader>gg", function() Snacks.lazygit() end,                     desc = "Lazygit" },
    { "<leader>gd", function() Snacks.picker.git_diff() end,             desc = "Git Diff (Hunks)" },

    -- Scratch
    { "<leader>s",  function() Snacks.scratch() end,                     desc = "Toggle Scratch Buffer" },
    { "<leader>S",  function() Snacks.scratch.select() end,              desc = "Select Scratch Buffer" },
  },
}
