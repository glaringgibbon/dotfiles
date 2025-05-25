return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {
          filetypes = {
            "sh",
            "bash",
            "zsh",
          },
          settings = {
            bashIde = {
              globPattern = "*@(.sh|.inc|.bash|.command|.zsh)",
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
      table.insert(opts.ensure_installed, "bash-language-server")
      table.insert(opts.ensure_installed, "shellcheck")
      table.insert(opts.ensure_installed, "shfmt")
    end,
  },
}
