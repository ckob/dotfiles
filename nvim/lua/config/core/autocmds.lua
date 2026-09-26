-- Highlight on yank
local yank_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
})

-- Set conceallevel and wrap for Markdown / Obsidian files
local markdown_group = vim.api.nvim_create_augroup("MarkdownSettings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = markdown_group,
  pattern = { "markdown", "obsidian" },
  callback = function()
    vim.opt_local.conceallevel = 2
    vim.opt_local.wrap = true
  end,
})

-- Background sync on save Obsidian
local vault_path = vim.fn.expand("~/ObsidianNotes")
local sync_script = vault_path .. "/sync.sh"
local sync_group = vim.api.nvim_create_augroup("ObsidianSync", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = sync_group,
  pattern = vault_path .. "/*",
  callback = function()
    if vim.fn.executable(sync_script) == 1 then
      vim.fn.jobstart({ sync_script }, { detach = true })
    end
  end,
})
