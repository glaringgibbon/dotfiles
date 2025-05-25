return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = {
                globals = {
                  "require",
                  "table",
                  "string",
                  "math",
                },
              },
            },
          },
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      local ensure_installed = {
        "lua-language-server",
        "stylua",
      }
      opts.ensure_installed = opts.ensure_installed or {}
      for _, server in ipairs(ensure_installed) do
        table.insert(opts.ensure_installed, server)
      end
    end,
  },
}
