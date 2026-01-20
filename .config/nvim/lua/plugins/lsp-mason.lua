return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- Python (handled by Python extra)
        "debugpy",
        "pyright",
        "ruff",
        "mypy",

        -- Lua
        "lua-language-server",
        "stylua",
        "selene",

        -- Web / Frontend
        "css-lsp",
        "html-lsp",
        "emmet-ls",
        "typescript-language-server",
        "prettierd",
        "eslint_d",
        "js-debug-adapter",

        -- PHP / WordPress
        "intelephense",
        "php-cs-fixer",
        "php-debug-adapter",
        "phpstan",

        -- Shell
        "bash-language-server",
        "shfmt",
        "shellcheck",

        -- Markup & Config
        "lemminx", -- XML
        "yaml-language-server", -- YAML
        "yamllint", -- YAML lint
        "json-lsp", -- JSON
        "taplo", -- TOML

        -- SQL (optional – uncomment if you keep SQLS)
        -- "sqls",
        -- "sqlfluff",
        -- "sql-formatter",

        -- CSS/SCSS
        "stylelint",

        -- Rust
        "rust-analyzer",
        "codelldb",

        -- Go
        "gopls",
        "delve",
      },
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      max_concurrent_installers = 10,
    },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_installation = true,
    },
  },
}
