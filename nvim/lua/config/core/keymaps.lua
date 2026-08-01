vim.g.mapleader = " "

local keymap = vim.keymap.set


-- Common Mappings

keymap({ "n", "v" }, "<leader>p", '"_dP', { desc = "Paste without overwriting the clipboard" })

keymap("v", ">", ">gv", { desc = "Indent selected lines while keeping selection" })
keymap("v", "<", "<gv", { desc = "Unindent selected lines while keeping selection" })

keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

keymap({ "n", "v" }, "<leader>or", function()
  local file = vim.fn.expand("%:p")
  local line = vim.fn.line(".")
  local col = vim.fn.col(".") - 1
  vim.fn.system(string.format('rider --line %d --column %d "%s"', line, col, file))
end, { desc = "Open current file in Rider" })

keymap({ "n", "v" }, "<leader>oc", function()
  local file = vim.fn.expand("%:p")
  local line = vim.fn.line(".")
  local col = vim.fn.col(".")
  vim.fn.system(string.format('code --goto "%s:%d:%d"', file, line, col))
end, { desc = "Open current file in VS Code" })

keymap({ "n", "v" }, "<leader>oC", function()
  local file = vim.fn.expand("%:p")
  local line = vim.fn.line(".")
  local col = vim.fn.col(".")
  local cwd = vim.fn.getcwd()
  vim.fn.system(string.format('code "%s" --goto "%s:%d:%d"', cwd, file, line, col))
end, { desc = "Open current file and CWD in VS Code" })

-- Only native Neovim
if not vim.g.vscode then
  -- In vscode is set in settings.json
  keymap("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
end

-- Only VSCode Neovim
if vim.g.vscode then
  -- Diagnostics
  keymap({ "n", "v" }, "]d", "<cmd>lua require('vscode').action('editor.action.marker.next')<CR>")
  keymap({ "n", "v" }, "[d", "<cmd>lua require('vscode').action('editor.action.marker.prev')<CR>")
  keymap({ "n", "v" }, "]e", "<cmd>lua require('vscode').action('go-to-next-error.next.error')<CR>")
  keymap({ "n", "v" }, "[e", "<cmd>lua require('vscode').action('go-to-next-error.prev.error')<CR>")
  keymap({ "n", "v" }, "]w", "<cmd>lua require('vscode').action('go-to-next-error.next.warning')<CR>")
  keymap({ "n", "v" }, "[w", "<cmd>lua require('vscode').action('go-to-next-error.prev.warning')<CR>")

  -- Buffers
  keymap(
    { "n", "v" },
    "<leader>bb",
    "<cmd>lua require('vscode').action('workbench.action.openPreviousEditorFromHistory')<CR><cmd>lua require('vscode').action('workbench.action.acceptSelectedQuickOpenItem')<CR>"
  )
  keymap({ "n", "v" }, "<leader>bd", "<cmd>lua require('vscode').action('workbench.action.closeActiveEditor')<CR>")
  keymap({ "n", "v" }, "<leader>bo", "<cmd>lua require('vscode').action('workbench.action.closeOtherEditors')<CR>")
  keymap({ "n", "v" }, "H", "<cmd>lua require('vscode').action('workbench.action.previousEditor')<CR>")
  keymap({ "n", "v" }, "L", "<cmd>lua require('vscode').action('workbench.action.nextEditor')<CR>")

  -- Lazygit
  keymap({ "n", "v" }, "<leader>gg", "<cmd>lua require('vscode').action('lazygit-vscode.toggle')<CR>")

  -- Terminal
  -- keymap({ "n", "v" }, "<leader>ft", "<cmd>lua require('vscode').action('workbench.action.createTerminalEditor')<CR>")

  -- LSP Navigation
  keymap({ "n" }, "gh", "<cmd>lua require('vscode').action('editor.action.showDefinitionPreviewHover')<CR>")
  keymap({ "n" }, "gd", "<cmd>lua require('vscode').action('editor.action.revealDefinition')<CR>")
  keymap({ "n" }, "gr", "<cmd>lua require('vscode').action('editor.action.goToReferences')<CR>")
  keymap({ "n" }, "gD", "<cmd>lua require('vscode').action('editor.action.revealDeclaration')<CR>")
  keymap({ "n" }, "gI", "<cmd>lua require('vscode').action('editor.action.goToImplementation')<CR>")
  keymap({ "n" }, "gy", "<cmd>lua require('vscode').action('editor.action.goToTypeDefinition')<CR>")

  -- Code Actions
  keymap({ "n", "v" }, "<leader>ca", "<cmd>lua require('vscode').action('editor.action.quickFix')<CR>")
  keymap({ "n" }, "<leader>cr", "<cmd>lua require('vscode').action('editor.action.rename')<CR>")
  keymap({ "n" }, "<leader>cf", "<cmd>lua require('vscode').action('editor.action.formatDocument')<CR>")
  keymap({ "v" }, "<leader>cf", "<cmd>lua require('vscode').action('editor.action.formatSelection')<CR>")

  -- Explorer
  keymap(
    { "n", "v" },
    "<leader>ef",
    "<cmd>lua require('vscode').action('workbench.files.action.showActiveFileInExplorer')<CR>"
  )
  keymap(
    { "n", "v" },
    "<leader>ee",
    "<cmd>lua require('vscode').action('workbench.action.toggleSidebarVisibility')<CR>"
  )

  -- Find
  -- keymap({ "n", "v" }, "<leader>fs", "<cmd>lua require('vscode').action('workbench.action.quickTextSearch')<CR>")
  -- keymap({ "n", "v" }, "<leader>ff", "<cmd>lua require('vscode').action('workbench.action.quickOpen')<CR>")
  keymap({ "n", "v" }, "<leader>ff", "<cmd>lua require('vscode').action('television.ToggleFileFinder')<CR>")
  keymap({ "n", "v" }, "<leader>fs", "<cmd>lua require('vscode').action('television.ToggleTextFinder')<CR>")

  -- Zen Mode
  keymap({ "n", "v" }, "<leader>uz", "<cmd>lua require('vscode').action('workbench.action.toggleZenMode')<CR>")

  -- Testing
  keymap({ "n", "v" }, "<leader>tl", "<cmd>lua require('vscode').action('testing.runLast')<CR>")
  keymap({ "n", "v" }, "<leader>to", "<cmd>lua require('vscode').action('workbench.panel.testResults.view.focus')<CR>")
  keymap({ "n", "v" }, "<leader>tO", "<cmd>lua require('vscode').action('workbench.view.extension.test')<CR>")
  keymap({ "n", "v" }, "<leader>tr", "<cmd>lua require('vscode').action('testing.runAtCursor')<CR>")
  keymap({ "n", "v" }, "<leader>ts", "<cmd>lua require('vscode').action('testing.showMostRecentOutput')<CR>")
  keymap({ "n", "v" }, "<leader>tS", "<cmd>lua require('vscode').action('testing.cancelRun')<CR>")
  keymap({ "n", "v" }, "<leader>tt", "<cmd>lua require('vscode').action('testing.runCurrentFile')<CR>")
  keymap({ "n", "v" }, "<leader>tT", "<cmd>lua require('vscode').action('testing.runAll')<CR>")
  keymap({ "n", "v" }, "<leader>td", "<cmd>lua require('vscode').action('testing.debugAtCursor')<CR>")

  -- Debug
  keymap({ "n", "v" }, "<leader>db", "<cmd>lua require('vscode').action('editor.debug.action.toggleBreakpoint')<CR>")
  keymap({ "n", "v" }, "<leader>dr", "<cmd>lua require('vscode').action('workbench.action.debug.start')<CR>")
  keymap({ "n", "v" }, "<leader>dc", "<cmd>lua require('vscode').action('workbench.action.debug.continue')<CR>")
  keymap({ "n", "v" }, "<leader>dP", "<cmd>lua require('vscode').action('workbench.action.debug.pause')<CR>")
  keymap({ "n", "v" }, "<leader>di", "<cmd>lua require('vscode').action('workbench.action.debug.stepInto')<CR>")
  keymap({ "n", "v" }, "<leader>do", "<cmd>lua require('vscode').action('workbench.action.debug.stepOut')<CR>")
  keymap({ "n", "v" }, "<leader>dO", "<cmd>lua require('vscode').action('workbench.action.debug.stepOver')<CR>")
  keymap({ "n", "v" }, "<leader>dt", "<cmd>lua require('vscode').action('workbench.action.debug.stop')<CR>") -- Terminate

  -- Folding
  keymap("n", "za", "<Cmd>lua require('vscode').action('editor.toggleFold')<CR>")
  keymap("n", "zR", "<Cmd>lua require('vscode').action('editor.unfoldAll')<CR>")
  keymap("n", "zM", "<Cmd>lua require('vscode').action('editor.foldAll')<CR>")
  keymap("n", "zo", "<Cmd>lua require('vscode').action('editor.unfold')<CR>")
  keymap("n", "zO", "<Cmd>lua require('vscode').action('editor.unfoldRecursively')<CR>")
  keymap("n", "zc", "<Cmd>lua require('vscode').action('editor.fold')<CR>")
  keymap("n", "zC", "<Cmd>lua require('vscode').action('editor.foldRecursively')<CR>")
  keymap("n", "z1", "<Cmd>lua require('vscode').action('editor.foldLevel1')<CR>")
  keymap("n", "z2", "<Cmd>lua require('vscode').action('editor.foldLevel2')<CR>")
  keymap("n", "z3", "<Cmd>lua require('vscode').action('editor.foldLevel3')<CR>")
  keymap("n", "z4", "<Cmd>lua require('vscode').action('editor.foldLevel4')<CR>")
  keymap("n", "z5", "<Cmd>lua require('vscode').action('editor.foldLevel5')<CR>")
  keymap("n", "z6", "<Cmd>lua require('vscode').action('editor.foldLevel6')<CR>")
  keymap("n", "z7", "<Cmd>lua require('vscode').action('editor.foldLevel7')<CR>")
  keymap("x", "zV", "<Cmd>lua require('vscode').action('editor.foldAllExcept')<CR>")
end
