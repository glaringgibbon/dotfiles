-- $XDG_CONFIG_HOME/nvim/lua/plugins/lang-rust.lua

return {
  {
    "simrat39/rust-tools.nvim",
    enabled = require("config.state").is_language_ready("rust"),
    ft = "rust",
    opts = {
      tools = {
        inlay_hints = {
          auto = true,
        },
      },
      server = {
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      },
    },
  },
}
