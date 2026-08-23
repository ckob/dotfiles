-- Highlight on yank
local yank_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
})

-- Set conceallevel for Markdown / Obsidian files
local conceal_group = vim.api.nvim_create_augroup("MarkdownConceal", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = conceal_group,
  pattern = { "markdown", "obsidian" },
  callback = function()
    vim.opt_local.conceallevel = 2
  end,
})

-- Background sync on save Obsidian
local vault_path = vim.fn.expand("~/ObsidianNotes")
local sync_group = vim.api.nvim_create_augroup("ObsidianSync", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = sync_group,
  pattern = vault_path .. "/*",
  callback = function()
    vim.fn.jobstart({
      "/opt/homebrew/bin/rclone",
      "bisync",
      vault_path,
      "obsidian-webdav:/ObsidianNotes",
      "--local-unicode-normalization",
      "--size-only",
      "--quiet",
    })
  end,
})
