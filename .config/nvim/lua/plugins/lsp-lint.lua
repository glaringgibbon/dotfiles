-- lua/plugins/lsp-lint.lua
return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "ruff" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        css = { "stylelint" },
        scss = { "stylelint" },
        php = { "phpcs", "phpstan" },
        markdown = { "markdownlint" },
        yaml = { "ansible-lint" },
        sh = { "shellcheck" },
        lua = { "selene" },
        sql = { "sqlfluff" },
      },
    },
  },
}
