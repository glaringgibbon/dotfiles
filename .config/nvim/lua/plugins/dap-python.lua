return {
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local dap_python = require("dap-python")

      -- Find project .venv, same strategy as your pyright config
      local function find_python()
        local path = vim.fn.getcwd()
        while path ~= "/" do
          local venv_python = path .. "/.venv/bin/python"
          if vim.fn.executable(venv_python) == 1 then
            return venv_python
          end
          path = vim.fn.fnamemodify(path, ":h")
        end
        return "python"
      end

      dap_python.setup(find_python())

      -- Optional: extra helpers if you want them later:
      -- vim.keymap.set("n", "<leader>dn", dap_python.test_method, { desc = "Debug test method" })
      -- vim.keymap.set("n", "<leader>dN", dap_python.test_class, { desc = "Debug test class" })
      -- vim.keymap.set("v", "<leader>ds", dap_python.debug_selection, { desc = "Debug selection" })
    end,
  },
}
