-- $XDG_CONFIG_HOME/nvim/lua/plugins/core-diagnostics.lua

local vim = vim
local api = vim.api
local fn = vim.fn
local diagnostic = vim.diagnostic
local keymap = vim.keymap
local notify = vim.notify

-- Store functions in module table to maintain scope
local M = {
  virtual_text_active = false,
}

-- Utility function to create a window with diagnostics
function M.create_diagnostic_window(diagnostics, title)
  -- [existing create_diagnostic_window code]
end

-- Function to display diagnostics sorted by severity
function M.show_diagnostics_by_severity(workspace)
  -- [existing show_diagnostics_by_severity code]
end

-- Function to display diagnostics sorted by source
function M.show_diagnostics_by_source(workspace)
  -- [existing show_diagnostics_by_source code]
end

-- Function to display diagnostics sorted by code
function M.show_diagnostics_by_code(workspace)
  -- [existing show_diagnostics_by_code code]
end

-- Toggle virtual text
function M.toggle_virtual_text()
  -- [existing toggle_virtual_text code]
end

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Diagnostic signs
      local signs = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " ",
      }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- Base diagnostic configuration
      diagnostic.config({
        virtual_text = M.virtual_text_active,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      -- Keymaps
      keymap.set("n", "<leader>xv", M.toggle_virtual_text, { desc = "Toggle Virtual Text" })
      keymap.set("n", "<leader>xs", function()
        M.show_diagnostics_by_severity(false)
      end, { desc = "Buffer Diagnostics (Severity)" })
      keymap.set("n", "<leader>xS", function()
        M.show_diagnostics_by_severity(true)
      end, { desc = "Workspace Diagnostics (Severity)" })
      keymap.set("n", "<leader>xo", function()
        M.show_diagnostics_by_source(false)
      end, { desc = "Buffer Diagnostics (Source)" })
      keymap.set("n", "<leader>xO", function()
        M.show_diagnostics_by_source(true)
      end, { desc = "Workspace Diagnostics (Source)" })
      keymap.set("n", "<leader>xc", function()
        M.show_diagnostics_by_code(false)
      end, { desc = "Buffer Diagnostics (Code)" })
      keymap.set("n", "<leader>xC", function()
        M.show_diagnostics_by_code(true)
      end, { desc = "Workspace Diagnostics (Code)" })
    end,
  },
}
