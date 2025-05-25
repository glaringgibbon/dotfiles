-- File: lua/plugins/core-ranger.lua

-- Define vim API at the top to avoid undefined global 'vim' warnings
local vim = vim
local api = vim.api
local fn = vim.fn

-- Ensure proper handling of plugin spec
return {
  {
    "kevinhwang91/rnvimr",
    cmd = "RnvimrToggle",
    keys = {
      {
        "<leader>fm",
        function()
          vim.cmd("RnvimrToggle")
        end,
        desc = "Toggle Ranger",
      },
    },
    config = function()
      -- Make Ranger replace Netrw and handle file/directory operations
      vim.g.rnvimr_enable_ex = 1

      -- Make Ranger to be hidden after picking a file
      vim.g.rnvimr_enable_picker = 1

      -- Replace `$EDITOR` candidate with this command to open the selected file
      vim.g.rnvimr_edit_cmd = "drop"

      -- Disable a border for floating window
      vim.g.rnvimr_draw_border = 0

      -- Hide the files included in gitignore
      vim.g.rnvimr_hide_gitignore = 1

      -- Set up initial layout
      vim.g.rnvimr_layout = {
        relative = "editor",
        width = fn.float2nr(fn.round(0.9 * api.nvim_win_get_width(0))),
        height = fn.float2nr(fn.round(0.9 * api.nvim_win_get_height(0))),
        col = fn.float2nr(fn.round(0.05 * api.nvim_win_get_width(0))),
        row = fn.float2nr(fn.round(0.05 * api.nvim_win_get_height(0))),
        style = "minimal",
      }

      -- Make Neovim wipe the buffers corresponding to the files deleted by Ranger
      vim.g.rnvimr_enable_bw = 1

      -- Add a shadow window, value is equal to 100 will disable shadow
      vim.g.rnvimr_shadow_winblend = 70

      -- Additional keymaps inside Ranger window
      vim.g.rnvimr_action = {
        ["<C-t>"] = "NvimEdit tabedit",
        ["<C-x>"] = "NvimEdit split",
        ["<C-v>"] = "NvimEdit vsplit",
        ["gw"] = "JumpNvimCwd",
        ["yw"] = "EmitRangerCwd",
      }

      -- Add custom commands
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "rnvimr",
        callback = function()
          -- Map Esc to quit
          vim.keymap.set("t", "<Esc>", "<C-\\><C-n>:RnvimrToggle<CR>", { buffer = true })
        end,
      })
    end,
    -- Ensure ranger is available
    dependencies = {
      "kelly-lin/ranger.nvim", -- Fallback option if needed
    },
  },
}
