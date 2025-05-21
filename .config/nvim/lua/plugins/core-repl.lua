local api = vim.api
local fn = vim.fn
local opt = vim.opt_local
local keymap = vim.keymap

return {
  {
    "hkupty/iron.nvim",
    cmd = {
      "IronRepl",
      "IronReplHere",
      "IronRestart",
      "IronFocus",
      "IronHide",
      "IronClear",
    },

    config = function()
      local iron = require("iron.core")
      local view = require("iron.view")

      -- Layout management
      local layout_state = {
        current = "vertical",
        cycle = {
          vertical = "horizontal",
          horizontal = "float",
          float = "vertical",
        },
      }

      local function cycle_layout()
        layout_state.current = layout_state.cycle[layout_state.current]
        iron.close_repl()
        iron.repl_here()
      end

      local function get_current_layout()
        local layouts = {
          vertical = view.split.vertical.botright(80),
          horizontal = view.split.horizontal.botright(15),
          float = view.float({
            border = "rounded",
            width = math.floor(api.nvim_get_option("columns") * 0.4),
            height = math.floor(api.nvim_get_option("lines") * 0.4),
          }),
        }
        return layouts[layout_state.current]
      end

      iron.setup({
        config = {
          scratch_repl = true,
          buflisted = false,
          close_on_exit = true,
          focus_on_open = true,
          ignore_blank_lines = true,
          highlight_last = true,
          repl_open_cmd = get_current_layout,

          repl_definition = {
            python = {
              command = { "ipython", "python" }, -- Fallback to python if ipython not available
              format = function(lines)
                if fn.executable("ipython") == 1 then
                  return {
                    -- Rich output configuration
                    "%config InteractiveShell.colors = 'Linux'\n",
                    "%config InteractiveShell.ast_node_interactivity='all'\n",
                    "%config InteractiveShell.syntax_style = 'monokai'\n",
                    -- Enhanced display options
                    "import sys, numpy as np\n",
                    "from pprint import pprint\n",
                    "try:\n",
                    "    from rich import print as rprint\n",
                    "    from rich.traceback import install as rich_traceback\n",
                    "    rich_traceback()\n",
                    "except ImportError:\n",
                    "    pass\n",
                    -- Numpy formatting
                    "np.set_printoptions(precision=3, suppress=True)\n",
                    -- Pandas configuration if available
                    "try:\n",
                    "    import pandas as pd\n",
                    "    pd.set_option('display.max_columns', None)\n",
                    "    pd.set_option('display.expand_frame_repr', False)\n",
                    "    pd.set_option('display.max_rows', 20)\n",
                    "except ImportError:\n",
                    "    pass\n",
                    -- Code execution
                    "%cpaste -q\n",
                    table.concat(lines, "\n"),
                    "\n--\n",
                  }
                else
                  return require("iron.fts.common").bracketed_paste(lines)
                end
              end,
            },

            javascript = {
              command = { "node" },
              format = function(lines)
                return {
                  -- Enhanced Node.js environment
                  "const util = require('util');\n",
                  "try {\n",
                  "    const chalk = require('chalk');\n",
                  "} catch {}\n",
                  -- Custom inspect function
                  "global.inspect = (obj) => console.log(util.inspect(obj, {\n",
                  "    depth: null,\n",
                  "    colors: true,\n",
                  "    maxArrayLength: null,\n",
                  "    maxStringLength: null\n",
                  "}));\n",
                  -- Pretty error handling
                  "process.on('uncaughtException', (err) => {\n",
                  "    console.error('\\x1b[31m%s\\x1b[0m', err.stack);\n",
                  "});\n",
                  ".editor\n",
                  table.concat(lines, "\n"),
                  "\n",
                  "\004",
                }
              end,
            },

            php = {
              command = { "php", "-a" },
              format = function(lines)
                return {
                  "<?php\n",
                  -- Error reporting
                  "error_reporting(E_ALL);\n",
                  "ini_set('display_errors', 1);\n",
                  -- Enhanced var_dump
                  "function enhanced_dump($var) {\n",
                  "    highlight_string('<?php\\n' . var_export($var, true));\n",
                  "    echo '\\n';\n",
                  "}\n",
                  -- Exception handling
                  "set_exception_handler(function($e) {\n",
                  "    echo '\\033[31m' . $e->getMessage() . '\\033[0m\\n';\n",
                  "    echo $e->getTraceAsString() . '\\n';\n",
                  "});\n",
                  table.concat(lines, "\n"),
                  "\n",
                }
              end,
            },

            mysql = {
              command = { "mysql", "-u", "root" },
              format = function(lines)
                return {
                  -- Enhanced MySQL formatting
                  "SET SESSION sql_mode = 'ONLY_FULL_GROUP_BY';\n",
                  "\\pager less -SFX\n",
                  "\\G\n",
                  "prompt \\033[32mmysql>\\033[0m\n",
                  "SELECT NOW() AS Current_Time;\n",
                  table.concat(lines, " ") .. ";\n",
                }
              end,
            },

            postgresql = {
              command = { "psql" },
              format = function(lines)
                return {
                  -- Enhanced PostgreSQL formatting
                  "\\pset linestyle unicode\n",
                  "\\pset border 2\n",
                  "\\pset null ¤\n",
                  "\\timing on\n",
                  table.concat(lines, " ") .. ";\n",
                }
              end,
            },

            sqlite3 = {
              command = { "sqlite3" },
              format = function(lines)
                return {
                  ".mode column\n",
                  ".headers on\n",
                  ".timer on\n",
                  table.concat(lines, " ") .. ";\n",
                }
              end,
            },

            lua = {
              command = { "lua" },
              format = function(lines)
                return {
                  -- Enhanced Lua output
                  "local inspect = require('inspect')\n",
                  "_G.pp = function(v) print(inspect(v)) end\n",
                  table.concat(lines, "\n"),
                  "\n",
                }
              end,
            },

            sh = {
              command = { "bash" },
              format = function(lines)
                return {
                  -- Enhanced bash output
                  "set -o pipefail\n",
                  "export PS1='\\[\\033[01;32m\\]bash\\[\\033[00m\\]> '\n",
                  "export HISTSIZE=10000\n",
                  "export HISTFILESIZE=20000\n",
                  table.concat(lines, "\n"),
                  "\n",
                }
              end,
            },

            zsh = {
              command = { "zsh" },
              format = function(lines)
                return {
                  -- Enhanced zsh output
                  "setopt EXTENDED_HISTORY\n",
                  "setopt HIST_EXPIRE_DUPS_FIRST\n",
                  "setopt HIST_IGNORE_DUPS\n",
                  "setopt HIST_IGNORE_ALL_DUPS\n",
                  "setopt HIST_IGNORE_SPACE\n",
                  "setopt HIST_FIND_NO_DUPS\n",
                  "setopt HIST_SAVE_NO_DUPS\n",
                  table.concat(lines, "\n"),
                  "\n",
                }
              end,
            },
          },
        },

        keymaps_on_attach = false,
        highlight = {
          italic = true,
          bold = true,
        },
      })

      -- Global keymaps (no filetype restriction needed)
      -- REPL management
      keymap.set("n", "<leader>is", "<cmd>IronRepl<cr>", { desc = "Start REPL" })
      keymap.set("n", "<leader>ir", "<cmd>IronRestart<cr>", { desc = "Restart REPL" })
      keymap.set("n", "<leader>if", "<cmd>IronFocus<cr>", { desc = "Focus REPL" })
      keymap.set("n", "<leader>ih", "<cmd>IronHide<cr>", { desc = "Hide REPL" })
      keymap.set("n", "<leader>il", cycle_layout, { desc = "Cycle REPL Layout" })

      -- Code sending
      keymap.set("v", "<leader>is", ":<C-u>'<,'>send<cr>", { desc = "Send Selection to REPL" })
      keymap.set("n", "<leader>ii", "<cmd>send<cr>", { desc = "Send Line to REPL" })
      keymap.set("n", "<leader>ia", "<cmd>%send<cr>", { desc = "Send File to REPL" })

      -- REPL control
      keymap.set("n", "<leader>i<space>", "<cmd>IronInterrupt<cr>", { desc = "Interrupt REPL" })
      keymap.set("n", "<leader>ic", "<cmd>IronClear<cr>", { desc = "Clear REPL" })
      keymap.set("n", "<leader>im", "<cmd>IronReplHere<cr>", { desc = "Mark for REPL" })

      -- REPL window appearance
      api.nvim_create_autocmd("FileType", {
        pattern = "iron",
        callback = function()
          opt.number = false
          opt.relativenumber = false
          opt.signcolumn = "no"
          opt.wrap = true
        end,
      })
    end,
  },
}
