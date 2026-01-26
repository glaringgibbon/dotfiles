return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}

      -- Python: ruff (lint) + mypy (type check)
      opts.linters_by_ft.python = { "ruff", "mypy" }
    end,
  },
}
