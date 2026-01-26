return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<C-\>]],
        hide_numbers = true,
        shade_terminals = true,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
      })
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      local Terminal = require("toggleterm.terminal").Terminal

      -- Define the terminals once so we can reference them in the keybinds
      local test_term = Terminal:new({ id = 1, direction = "horizontal", size = 15 })
      local float_term = Terminal:new({ id = 2, direction = "float" })
      local dep_term = Terminal:new({ id = 3, direction = "float" })

      opts.spec = opts.spec or {}
      vim.list_extend(opts.spec, {
        { "<leader>T", group = "toggleterm", icon = " " },
        {
          "<leader>Tt",
          function()
            test_term:toggle()
          end,
          desc = "Toggle Test Terminal (Horizontal)",
        },
        {
          "<leader>Tf",
          function()
            float_term:toggle()
          end,
          desc = "Toggle Float Terminal",
        },
        {
          "<leader>Td",
          function()
            dep_term:toggle()
          end,
          desc = "Toggle Dependency Terminal",
        },
      })
    end,
  },
}
