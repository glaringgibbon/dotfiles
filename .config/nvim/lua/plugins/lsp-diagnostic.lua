-- lua/plugins/lsp-diagnostic.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false, -- OFF by default
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "✘", --
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
          },
        },
      },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      vim.list_extend(opts.spec, {
        {
          "<leader>uv",
          function()
            local cfg = vim.diagnostic.config()
            local enabled = cfg.virtual_text ~= false
            vim.diagnostic.config({ virtual_text = not enabled })
            vim.notify("Virtual text diagnostics " .. (enabled and "disabled" or "enabled"), vim.log.levels.INFO)
          end,
          desc = "Toggle Virtual Text Diagnostics",
        },
      })
    end,
  },
}
