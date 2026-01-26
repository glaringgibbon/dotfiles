-- lua/plugins/tool-oil.lua
return {
  "stevearc/oil.nvim",
  opts = {
    view_options = {
      show_hidden = true,
    },
  },
  keys = {
    { "-", "<CMD>Oil<CR>", desc = "Open parent directory in Oil" },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
