local vim = vim
local state = require("config.state")
local notify = vim.notify

-- Helper function for debugpy setup
local function setup_debugpy()
  local mason_registry = require("mason-registry")
  if not mason_registry.is_installed("debugpy") then
    notify("Installing debugpy...", vim.log.levels.INFO)
    mason_registry.get_package("debugpy"):install()
  end
  return mason_registry.get_package("debugpy"):get_install_path() .. "/venv/bin/python"
end

return {
  {
    "neovim/nvim-lspconfig",
    enabled = function()
      return state.is_language_ready("python")
    end,
    opts = {
      servers = {
        pyright = {
          before_init = function(_, config)
            if not state.validate_provider("python") then
              notify("Python provider not properly configured", vim.log.levels.ERROR)
              return false
            end
            -- Additional pyright configuration can go here
          end,
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
              },
            },
          },
        },
        ruff_lsp = {
          keys = {
            {
              "<leader>co",
              function()
                require("ruff_lsp").organize_imports()
              end,
              desc = "Organize Imports",
            },
            {
              "<leader>cF",
              function()
                require("ruff_lsp").format()
              end,
              desc = "Format with Ruff",
            },
          },
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    enabled = function()
      return state.is_language_ready("python")
    end,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "debugpy",
        "pyright",
        "ruff",
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    enabled = function()
      return state.is_language_ready("python")
    end,
    dependencies = {
      "mfussenegger/nvim-dap-python",
      config = function()
        require("dap-python").setup(setup_debugpy())
      end,
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    enabled = function()
      return state.is_language_ready("python")
    end,
    cmd = "VenvSelect",
    opts = {
      name = {
        "venv",
        ".venv",
        "env",
        ".env",
      },
      parents = 0, -- Don't search parent directories for venvs
    },
    keys = {
      { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv" },
    },
  },
  {
    "mfussenegger/nvim-dap-python",
    enabled = function()
      return state.is_language_ready("python")
    end,
    config = function()
      local debugpy_python = setup_debugpy()
      require("dap-python").setup(debugpy_python)
      require("dap-python").test_runner = "pytest"
    end,
    keys = {
      {
        "<leader>dPt",
        function()
          require("dap-python").test_method()
        end,
        desc = "Debug Method",
      },
      {
        "<leader>dPc",
        function()
          require("dap-python").test_class()
        end,
        desc = "Debug Class",
      },
    },
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    enabled = function()
      return state.is_language_ready("python")
    end,
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          runner = "pytest",
          python = setup_debugpy,
        },
      },
    },
  },
}
