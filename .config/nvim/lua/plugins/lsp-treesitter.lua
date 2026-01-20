-- lua/plugins/lsp-treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- Core languages
        "lua",
        "vim",
        "vimdoc",
        "regex",

        -- Markup / Docs
        "markdown",
        "markdown_inline",
        "html",
        "xml",
        "json",
        "yaml",
        "toml",
        "latex",

        -- Shell
        "bash",

        -- Web / Frontend
        "css",
        "scss",
        "javascript",
        "typescript",

        -- Backend
        "php",
        "python",
        "go",
        "rust",
        "sql",
        "c",

        -- Dev Tools / Misc
        "gitcommit",
        "gitignore",
        "diff",
        "dockerfile",
        "make",
        "comment",
      },

      highlight = {
        enable = true,
      },

      indent = {
        enable = true,
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
  },
}
