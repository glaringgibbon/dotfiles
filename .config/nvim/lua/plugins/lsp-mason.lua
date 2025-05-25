return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Python
        "debugpy",
        "ruff",
        "mypy",
        "pyright",
        -- Lua
        "lua-language-server",
        "stylua",
        -- Web
        "css-lsp",
        "html-lsp",
        "typescript-language-server",
        "prettier",
        "eslint-lsp",
        -- PHP
        "intelephense",
        "php-debug-adapter",
        -- Shell
        "bash-language-server",
        "shfmt",
        -- XML/YAML/JSON/TOML
        "lemminx",
        "yaml-language-server",
        "json-lsp",
        "taplo",
        -- SQL
        --"sqls",
        --"sql-formatter",
        --"sqlfluff",
        -- KooKidz
        -- "gopls",
        -- "rust-analyzer",
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
    "williamboman/mason-lspconfig.nvim",
    opts = {
      automatic_installation = true,
    },
  },
}
