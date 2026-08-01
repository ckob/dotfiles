return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "json", "javascript", "typescript", "tsx", "yaml", "html", "css",
      "prisma", "markdown", "markdown_inline", "svelte", "bash", "lua",
      "vim", "dockerfile", "gitignore", "query", "vimdoc", "c", "c_sharp",
      "xml", "regex",
    },
  },
  config = function(_, opts)
    require("nvim-treesitter").setup(opts)

    vim.treesitter.language.register("bash", "zsh")
    vim.treesitter.language.register("gherkin", { "cucumber" })
  end,
}
