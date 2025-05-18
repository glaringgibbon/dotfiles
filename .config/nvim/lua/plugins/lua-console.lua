-- lua/plugins/lua-console.lua
-- TODO: AI generated potential upgrades
-- Add any specific formatting rules?
-- Modify the existing handlers?
-- Add color highlighting for different types?
-- Add more detailed metadata for specific types?

return {
  "YaroSpace/lua-console.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
  },
  opts = {
    -- Window settings
    split = "right", -- Change to "bottom" for horizontal split
    size = 50, -- width/height of console window
    border = "single", -- Available: "none", "single", "double", "rounded", "solid", "shadow"
    win_opts = {
      wrap = true, -- Wrap long lines
      number = true, -- Show line numbers
      cursorline = true, -- Highlight current line
    },

    -- Console settings
    console_title = "Lua Console",
    output_title = "Output",

    -- Output formatting
    output = {
      format = "detailed", -- More comprehensive output
      max_lines = 500,
      highlight_error = true, -- Highlight errors in red
      timestamp = true, -- Add timestamps to output
    },

    -- History settings
    history = {
      enabled = true,
      size = 100,
      persistent = true,
      -- Store history in XDG cache directory
      file = vim.fn.stdpath("cache") .. "/lua_console_history",
    },

    -- Keymaps within the console window
    -- These work when the console is focused
    mappings = {
      execute = "<CR>", -- Execute current line/selection
      clear_output = "<C-l>", -- Clear output window
      clear_console = "<C-k>", -- Clear console window
      toggle_output = "<C-o>", -- Toggle output window
      history_prev = "<C-p>", -- Previous history item
      history_next = "<C-n>", -- Next history item
    },
  },
  -- Global keymaps (available anywhere in Neovim)
  keys = {
    { "<leader>rt", "<cmd>LuaConsoleToggle<CR>", desc = "Toggle Lua Console" },
    { "<leader>re", "<cmd>LuaConsoleEval<CR>", desc = "Evaluate Lua" },
    { "<leader>rh", "<cmd>LuaConsoleHistory<CR>", desc = "Show History" },
    { "<leader>rc", "<cmd>LuaConsoleClear<CR>", desc = "Clear Console" },
    { "<leader>ro", "<cmd>LuaConsoleOutput<CR>", desc = "Toggle Output" },
  },
  config = function(_, opts)
    -- Enhanced output formatting
    local format_output = function(value)
      local type_handlers = {
        -- Tables/Arrays
        ["table"] = function(v)
          -- Check if it's an array-like table
          local is_array = #v > 0
          local items = {}

          if is_array then
            -- Format as array with indices
            for i, item in ipairs(v) do
              table.insert(items, string.format("[%d] = %s", i, vim.inspect(item)))
            end
            return "[\n  " .. table.concat(items, ",\n  ") .. "\n]"
          else
            -- Format as key-value pairs with types
            for key, val in pairs(v) do
              table.insert(items, string.format("%s (%s) = %s", tostring(key), type(val), vim.inspect(val)))
            end
            return "{\n  " .. table.concat(items, ",\n  ") .. "\n}"
          end
        end,

        -- Functions
        ["function"] = function(v)
          local info = debug.getinfo(v)
          return string.format(
            "Function: %s\n  Defined in: %s:%d\n  Parameters: %d",
            info.name or "anonymous",
            info.short_src,
            info.linedefined,
            info.nparams
          )
        end,

        -- Userdata/Objects
        ["userdata"] = function(v)
          local mt = getmetatable(v)
          if mt and mt.__tostring then
            return string.format("Userdata: %s\nMetatable: %s", tostring(v), vim.inspect(mt))
          end
          return vim.inspect(v)
        end,

        -- Strings with special formatting
        ["string"] = function(v)
          -- Check if it's multiline
          if v:find("\n") then
            return string.format("'''\n%s\n'''", v)
          end
          return vim.inspect(v)
        end,

        -- Numbers with type indication
        ["number"] = function(v)
          if v % 1 == 0 then
            return string.format("%d (integer)", v)
          else
            return string.format("%f (float)", v)
          end
        end,

        -- Boolean with style
        ["boolean"] = function(v)
          return string.format("%s (boolean)", tostring(v))
        end,

        -- Nil with explanation
        ["nil"] = function(_)
          return "nil (undefined)"
        end,

        -- Thread status
        ["thread"] = function(v)
          return string.format("Thread: %s (status: %s)", tostring(v), coroutine.status(v))
        end,
      }

      -- Fix timestamp type conversion warning
      -- This is due to Lua version vs LuaJIT as per AI convo
      local function get_timestamp()
        if opts.output.timestamp then
          return os.date("[%H:%M:%S] ")
        end
        return ""
      end

      -- Add timestamp if enabled
      local timestamp = get_timestamp()
      if opts.output.timestamp then
        timestamp = os.date("[%H:%M:%S] ")
      end

      -- Get the appropriate handler or fall back to vim.inspect
      local handler = type_handlers[type(value)] or vim.inspect
      return timestamp .. handler(value)
    end

    -- Apply the custom formatter
    opts.output.formatter = format_output
    require("lua-console").setup(opts)
  end,
}
