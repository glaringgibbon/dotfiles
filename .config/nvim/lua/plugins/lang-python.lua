return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
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
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "debugpy")
      table.insert(opts.ensure_installed, "pyright")
      table.insert(opts.ensure_installed, "ruff")
    end,
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "mfussenegger/nvim-dap-python",
      config = function()
        local mason_registry = require("mason-registry")
        -- Ensure debugpy is installed
        if not mason_registry.is_installed("debugpy") then
          vim.notify("Installing debugpy...", vim.log.levels.INFO)
          mason_registry.get_package("debugpy"):install()
        end
        -- Setup dap-python with the installed debugpy
        local debugpy_path = mason_registry.get_package("debugpy"):get_install_path()
        require("dap-python").setup(debugpy_path .. "/venv/bin/python")
      end,
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    opts = {
      name = {
        "venv",
        ".venv",
        "env",
        ".env",
      },
    },
    keys = {
      { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv" },
    },
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      local mason_registry = require("mason-registry")
      -- Ensure debugpy is installed
      if not mason_registry.is_installed("debugpy") then
        vim.notify("Installing debugpy...", vim.log.levels.INFO)
        mason_registry.get_package("debugpy"):install()
      end
      -- Setup dap-python with the installed debugpy
      local debugpy_path = mason_registry.get_package("debugpy"):get_install_path()
      require("dap-python").setup(debugpy_path .. "/venv/bin/python")
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
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          runner = "pytest",
          python = function()
            local mason_registry = require("mason-registry")
            if not mason_registry.is_installed("debugpy") then
              vim.notify("Installing debugpy...", vim.log.levels.INFO)
              mason_registry.get_package("debugpy"):install()
            end
            return mason_registry.get_package("debugpy"):get_install_path() .. "/venv/bin/python"
          end,
        },
      },
    },
  },
}
