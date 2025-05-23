-- $XDG_CONFIG_HOME/nvim/lua/plugins/lang-node.lua

local vim = vim
local state = require("config.state")
local notify = vim.notify

return {
  {
    "neovim/nvim-lspconfig",
    enabled = function()
      return state.is_language_ready("node")
    end,
    opts = {
      servers = {
        tsserver = {
          before_init = function(_, config)
            if not state.validate_provider("node") then
              notify("Node.js provider not properly configured", vim.log.levels.WARN)
              -- Don't return false here as Node provider is optional
            end
          end,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
        eslint = {
          enabled = function()
            return state.is_language_ready("node")
          end,
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    enabled = function()
      return state.is_language_ready("node")
    end,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "typescript-language-server",
        "eslint-lsp",
        "prettier",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if state.is_language_ready("node") then
        vim.list_extend(opts.ensure_installed or {}, {
          "javascript",
          "typescript",
          "tsx",
        })
      end
    end,
  },
}
