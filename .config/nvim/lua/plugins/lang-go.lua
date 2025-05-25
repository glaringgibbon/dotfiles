-- $XDG_CONFIG_HOME/nvim/lua/plugins/lang-go.lua
local g = vim.g
return {
  {
    "fatih/vim-go",
    enabled = require("config.state").is_language_ready("go"),
    ft = "go",
    config = function()
      g.go_highlight_functions = 1
      g.go_highlight_methods = 1
      g.go_highlight_structs = 1
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          enabled = require("config.state").is_language_ready("go"),
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
            },
          },
        },
      },
    },
  },
}
