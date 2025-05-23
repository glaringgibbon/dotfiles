-- $XDG_CONFIG_HOME/nvim/lua/plugins/lang-rust.lua

local vim = vim
local state = require("config.state")
local notify = vim.notify

return {
  {
    "simrat39/rust-tools.nvim",
    enabled = function()
      return state.is_language_ready("rust")
    end,
    ft = "rust",
    opts = {
      tools = {
        -- Inlay hints
        inlay_hints = {
          auto = true,
          only_current_line = false,
          show_parameter_hints = true,
          parameter_hints_prefix = "<- ",
          other_hints_prefix = "=> ",
          max_len_align = false,
          max_len_align_padding = 1,
          right_align = false,
          right_align_padding = 7,
          highlight = "Comment",
        },
        -- Hover actions
        hover_actions = {
          border = {
            { "╭", "FloatBorder" },
            { "─", "FloatBorder" },
            { "╮", "FloatBorder" },
            { "│", "FloatBorder" },
            { "╯", "FloatBorder" },
            { "─", "FloatBorder" },
            { "╰", "FloatBorder" },
            { "│", "FloatBorder" },
          },
          auto_focus = true,
        },
      },
      server = {
        before_init = function(_, config)
          if not state.validate_provider("rust") then
            notify("Rust environment not properly configured", vim.log.levels.WARN)
            return false
          end
        end,
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
              extraArgs = { "--all", "--", "-W", "clippy::all" },
            },
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            procMacro = {
              enable = true,
            },
            diagnostics = {
              enable = true,
              experimental = {
                enable = true,
              },
            },
          },
        },
        standalone = true,
      },
    },
    config = function(_, opts)
      require("rust-tools").setup(opts)
    end,
  },
  {
    "williamboman/mason.nvim",
    enabled = function()
      return state.is_language_ready("rust")
    end,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "rust-analyzer",
        "codelldb",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if state.is_language_ready("rust") then
        vim.list_extend(opts.ensure_installed or {}, {
          "rust",
          "toml", -- for Cargo.toml
        })
      end
    end,
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    enabled = function()
      return state.is_language_ready("rust")
    end,
    dependencies = {
      {
        "simrat39/rust-tools.nvim",
        config = function()
          local mason_registry = require("mason-registry")
          local codelldb = mason_registry.get_package("codelldb")
          local extension_path = codelldb:get_install_path() .. "/extension/"
          local codelldb_path = extension_path .. "adapter/codelldb"
          local liblldb_path = extension_path .. "lldb/lib/liblldb"
          local this_os = vim.loop.os_uname().sysname

          -- The path is different on Windows
          if this_os:find("Windows") then
            codelldb_path = extension_path .. "adapter\\codelldb.exe"
            liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
          else
            -- The liblldb extension is .so on Linux and .dylib on macOS
            liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
          end

          require("rust-tools").setup({
            dap = {
              adapter = require("rust-tools.dap").get_codelldb_adapter(
                codelldb_path,
                liblldb_path
              ),
            },
          })
        end,
      },
    },
  },
}
