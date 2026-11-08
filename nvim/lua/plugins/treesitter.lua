local parsers = {
  "json", "javascript", "typescript", "tsx", "yaml", "html", "css",
  "prisma", "markdown", "markdown_inline", "svelte", "bash", "lua",
  "vim", "dockerfile", "gitignore", "query", "vimdoc", "c", "c_sharp",
  "xml", "regex", "helm",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup()
    -- On the main branch, setup() no longer accepts ensure_installed.
    require("nvim-treesitter").install(parsers)

    vim.treesitter.language.register("bash", "zsh")
    vim.treesitter.language.register("gherkin", { "cucumber" })
  end,
}
