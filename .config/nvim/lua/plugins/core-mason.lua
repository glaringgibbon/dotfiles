local vim = vim
local state = require("config.state")

return {
  {
    "williamboman/mason.nvim",
    opts = function()
      -- Build ensure_installed list based on configured languages
      local ensure_installed = {
        -- Base tools (always installed)
        -- Shell
        "bash-language-server",
        "shfmt",
        -- Data formats
        "lemminx", -- XML
        "yaml-language-server",
        "json-lsp",
        "taplo", -- TOML
        -- SQL
        "sqls",
        "sql-formatter",
        "sqlfluff",
      }

      -- Python (required)
      if state.is_language_ready("python") then
        local python_tools = {
          "debugpy",
          "ruff",
          "mypy",
          "pyright",
          "black",
          "isort",
        }
        vim.list_extend(ensure_installed, python_tools)
      end

      -- Go (optional)
      if state.is_language_ready("go") then
        vim.list_extend(ensure_installed, { "gopls" })
      end

      -- Rust (optional)
      if state.is_language_ready("rust") then
        vim.list_extend(ensure_installed, { "rust-analyzer" })
      end

      -- Node.js (optional)
      if state.is_language_ready("node") then
        local web_tools = {
          "css-lsp",
          "html-lsp",
          "typescript-language-server",
          "prettier",
          "eslint-lsp",
        }
        vim.list_extend(ensure_installed, web_tools)
      end

      -- Return the complete configuration
      return {
        ensure_installed = ensure_installed,
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
        max_concurrent_installers = 10,
      }
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      automatic_installation = true,
    },
  },
}
