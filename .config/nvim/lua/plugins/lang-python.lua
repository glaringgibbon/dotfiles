return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
              },
            },
          },
        },
      },
      setup = {
        pyright = function(_, opts)
          local function find_venv(start_path)
            local path = start_path
            while path ~= "/" do
              local venv = path .. "/.venv"
              if vim.fn.isdirectory(venv) == 1 then
                return venv
              end
              path = vim.fn.fnamemodify(path, ":h")
            end
            return nil
          end

          local venv = find_venv(vim.fn.getcwd())
          if venv then
            opts.settings.python.pythonPath = venv .. "/bin/python"
          end
        end,
      },
    },
  },
  -- Python-specific keybindings using Toggleterm
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      -- Helper to get or create the dependency terminal (ID 3)
      local function get_dep_term()
        local Terminal = require("toggleterm.terminal").Terminal
        local term = require("toggleterm.terminal").get(3)
        if not term then
          term = Terminal:new({
            id = 3,
            cmd = "zsh",
            direction = "float",
            on_open = function(t)
              vim.cmd("startinsert!")
            end,
          })
        end
        return term
      end

      opts.spec = opts.spec or {}
      vim.list_extend(opts.spec, {
        { "<leader>p", group = "python", icon = "" },

        -- Running tests/checks in the horizontal bottom terminal (ID 1)
        {
          "<leader>pt",
          function()
            local term = require("toggleterm.terminal").get(1)
            if not term then
              require("toggleterm").toggle(1, 15, nil, "horizontal")
            end
            require("toggleterm.terminal").get(1):send("uv run pytest\n")
          end,
          desc = "Run Pytest",
        },
        {
          "<leader>pc",
          function()
            local term = require("toggleterm.terminal").get(1)
            if not term then
              require("toggleterm").toggle(1, 15, nil, "horizontal")
            end
            require("toggleterm.terminal").get(1):send("uv run pytest --cov\n")
          end,
          desc = "Run Pytest + Coverage",
        },
        {
          "<leader>pm",
          function()
            local term = require("toggleterm.terminal").get(1)
            if not term then
              require("toggleterm").toggle(1, 15, nil, "horizontal")
            end
            require("toggleterm.terminal").get(1):send("uv run mypy .\n")
          end,
          desc = "Run Mypy (Project)",
        },
        {
          "<leader>pr",
          function()
            local term = require("toggleterm.terminal").get(1)
            if not term then
              require("toggleterm").toggle(1, 15, nil, "horizontal")
            end
            require("toggleterm.terminal").get(1):send("uv run ruff check .\n")
          end,
          desc = "Run Ruff (Project)",
        },
        -- Dependency Management in the floating terminal (ID 3)
        {
          "<leader>pa",
          function()
            vim.ui.input({ prompt = "Package to add: " }, function(input)
              if input and #input > 0 then
                local term = get_dep_term()
                term:toggle()
                term:send("uv add " .. input .. "\n")
              end
            end)
          end,
          desc = "Add Dependency",
        },
        {
          "<leader>pA",
          function()
            vim.ui.input({ prompt = "Dev package to add: " }, function(input)
              if input and #input > 0 then
                local term = get_dep_term()
                term:toggle()
                term:send("uv add --dev " .. input .. "\n")
              end
            end)
          end,
          desc = "Add Dev Dependency",
        },
        {
          "<leader>px",
          function()
            vim.ui.input({ prompt = "Package to remove: " }, function(input)
              if input and #input > 0 then
                local term = get_dep_term()
                term:toggle()
                term:send("uv remove " .. input .. "\n")
              end
            end)
          end,
          desc = "Remove Dependency",
        },

        -- Logging Level Toggles
        {
          "<leader>pld",
          function()
            vim.fn.setenv("LOG_LEVEL", "DEBUG")
            vim.notify("LOG_LEVEL=DEBUG", vim.log.levels.INFO)
          end,
          desc = "Set Log Level: DEBUG",
        },
        {
          "<leader>pli",
          function()
            vim.fn.setenv("LOG_LEVEL", "INFO")
            vim.notify("LOG_LEVEL=INFO", vim.log.levels.INFO)
          end,
          desc = "Set Log Level: INFO",
        },
        {
          "<leader>plw",
          function()
            vim.fn.setenv("LOG_LEVEL", "WARNING")
            vim.notify("LOG_LEVEL=WARNING", vim.log.levels.INFO)
          end,
          desc = "Set Log Level: WARNING",
        },
        {
          "<leader>ple",
          function()
            vim.fn.setenv("LOG_LEVEL", "ERROR")
            vim.notify("LOG_LEVEL=ERROR", vim.log.levels.INFO)
          end,
          desc = "Set Log Level: ERROR",
        },
      })
    end,
  },
}
