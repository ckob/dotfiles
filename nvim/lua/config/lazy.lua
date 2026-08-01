local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

if vim.g.vscode then
  -- Load only VSCode specific plugins
  require("lazy").setup({ { import = "vscodeplugins" } }, {
    checker = { enabled = false },
    change_detection = { notify = false },
  })
else
  -- Load regular plugins when not in VSCode
  require("lazy").setup({ { import = "plugins" } }, {
    checker = { enabled = true, notify = false },
    change_detection = { notify = false },
  })
end