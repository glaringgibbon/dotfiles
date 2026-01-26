return {
  {
    "hkupty/iron.nvim",
    config = function()
      local iron = require("iron.core")

      iron.setup({
        config = {
          repl_open_cmd = require("iron.view").split.vertical.botright(0.5),
          repl_definition = {
            python = {
              command = function()
                -- We use 'uv run' because it handles the venv pathing perfectly
                -- --quiet prevents uv from printing 'Reading/Installing' messages into the REPL
                return { "uv", "run", "--quiet", "ipython", "--no-autoindent" }
              end,
            },
          },
        },
        keymaps = {},
        ignore_blank_lines = true,
      })

      -- REPL Management
      vim.keymap.set("n", "<leader>pi", function()
        iron.repl_for("python")
      end, { desc = "Open REPL" })
      vim.keymap.set("n", "<leader>pq", function()
        iron.close_repl("python")
      end, { desc = "Close REPL" })
      vim.keymap.set("n", "<leader>pl", function()
        iron.repl_for("python"):clear()
      end, { desc = "Clear REPL" })

      -- Sending Code
      vim.keymap.set("n", "<leader>ps", function()
        iron.send_line()
      end, { desc = "Send Line" })
      vim.keymap.set("v", "<leader>ps", function()
        iron.visual_send()
      end, { desc = "Send Selection" })
      vim.keymap.set("n", "<leader>pf", function()
        iron.send_motion("ip")
      end, { desc = "Send Function/Paragraph" })

      -- Project Management
      vim.keymap.set("n", "<leader>prl", function()
        iron.send(
          nil,
          "import importlib; import sys; [importlib.reload(m) for m in list(sys.modules.values()) if m and hasattr(m, '__file__') and 'site-packages' not in str(m.__file__)]\n"
        )
      end, { desc = "Reload Project Modules" })
    end,
  },
}
