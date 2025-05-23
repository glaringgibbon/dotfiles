-- $XDG_CONFIG_HOME/nvim/lua/plugins/lang-go.lua

local vim = vim
local state = require("config.state")
local notify = vim.notify

return {
  {
    "fatih/vim-go",
    enabled = function()
      return state.is_language_ready("go")
    end,
    ft = "go",
    config = function()
      -- Basic highlighting
      vim.g.go_highlight_functions = 1
      vim.g.go_highlight_methods = 1
      vim.g.go_highlight_structs = 1
      
      -- Additional useful highlights
      vim.g.go_highlight_operators = 1
      vim.g.go_highlight_build_constraints = 1
      vim.g.go_highlight_types = 1
      
      -- Let LSP handle these
      vim.g.go_code_completion_enabled = 0
      vim.g.go_def_mapping_enabled = 0
      vim.g.go_gopls_enabled = 0
    end,
  },
  {
    "neovim/nvim-lspconfig",
    enabled = function()
      return state.is_language_ready("go")
    end,
    opts = {
      servers = {
        gopls = {
          before_init = function(_, config)
            if not state.validate_provider("go") then
              notify("Go environment not properly configured", vim.log.levels.WARN)
              return false
            end
          end,
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                shadow = true,
                nilness = true,
                unusedwrite = true,
                useany = true,
              },
              staticcheck = true,
              gofumpt = true,
              codelenses = {
                gc_details = true,
                generate = true,
                regenerate_cgo = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              semanticTokens = true,
            },
          },
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    enabled = function()
      return state.is_language_ready("go")
    end,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "gopls",
        "golangci-lint",
        "gofumpt",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if state.is_language_ready("go") then
        vim.list_extend(opts.ensure_installed or {}, {
          "go",
          "gomod",
          "gowork",
          "gosum",
        })
      end
    end,
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    enabled = function()
      return state.is_language_ready("go")
    end,
    dependencies = {
      {
        "leoluz/nvim-dap-go",
        config = true,
      },
    },
    keys = {
      {
        "<leader>dgt",
        function()
          require("dap-go").debug_test()
        end,
        desc = "Debug Go Test",
      },
      {
        "<leader>dgl",
        function()
          require("dap-go").debug_last_test()
        end,
        desc = "Debug Last Go Test",
      },
    },
  },
}
