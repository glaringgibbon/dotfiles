-- $XDG_CONFIG_HOME/nvim/lua/plugins/lang-javascript.lua
local state = require("config.state")
local notify = vim.notify

return {
  -- Base LSP configuration
  {
    "neovim/nvim-lspconfig",
    enabled = function()
      return state.is_language_ready("node")
    end,
    opts = {
      servers = {
        -- TypeScript/JavaScript LSP
        tsserver = {
          before_init = function(_, config)
            if not state.validate_provider("node") then
              notify("Node.js provider not properly configured", vim.log.levels.WARN)
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
        -- ESLint
        eslint = {
          enabled = function()
            return state.is_language_ready("node")
          end,
        },
      },
    },
  },

  -- Mason packages
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
        "js-debug-adapter",
      })
    end,
  },

  -- Treesitter
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

  -- TypeScript Tools (only enabled when node is ready)
  {
    "pmizio/typescript-tools.nvim",
    enabled = function()
      return state.is_language_ready("node")
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      settings = {
        tsserver_file_preferences = {
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

  -- TypeScript Compiler integration
  {
    "dmmulroy/tsc.nvim",
    enabled = function()
      return state.is_language_ready("node")
    end,
    cmd = { "TSC" },
    opts = {},
  },

  -- Debug Adapter
  {
    "mfussenegger/nvim-dap",
    optional = true,
    enabled = function()
      return state.is_language_ready("node")
    end,
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, "js-debug-adapter")
        end,
      },
    },
    opts = function()
      local dap = require("dap")
      if not dap.adapters["pwa-node"] then
        dap.adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = {
              require("mason-registry").get_package("js-debug-adapter"):get_install_path()
                .. "/js-debug/src/dapDebugServer.js",
              "${port}",
            },
          },
        }
      end
      for _, language in ipairs({ "typescript", "javascript" }) do
        if not dap.configurations[language] then
          dap.configurations[language] = {
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch file",
              program = "${file}",
              cwd = "${workspaceFolder}",
            },
            {
              type = "pwa-node",
              request = "attach",
              name = "Attach",
              processId = require("dap.utils").pick_process,
              cwd = "${workspaceFolder}",
            },
          }
        end
      end
    end,
  },
}
