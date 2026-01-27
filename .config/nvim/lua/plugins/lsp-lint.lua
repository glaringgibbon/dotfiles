return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}

      -- Python: ruff (lint) + mypy (type check)
      opts.linters_by_ft.python = { "ruff", "mypy" }
      --
      opts.linters_by_ft.javascript = { "eslint_d" }
      opts.linters_by_ft.typescript = { "eslint_d" }
    end,
  },
}
