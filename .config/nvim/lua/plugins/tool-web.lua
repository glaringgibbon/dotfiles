-- lua/plugins/web-tools.lua
return {
  {
    "olrtg/nvim-emmet",
    dependencies = {
      "olrtg/emmet-language-server",
    },
  },
  {
    "brianhuster/live-preview.nvim",
    config = function()
      require("live-preview").setup({
        -- Default config
        auto_refresh = true,
        refresh_rate = 1000,
        highlight = {
          enabled = true,
          timeout = 1000,
        },
        browser = "default",
        port = 8090,
        patterns = {
          "*.html",
          "*.css",
          "*.js",
          "*.md",
        },
      })
    end,
    keys = {
      { "<leader>lp", "<cmd>LivePreviewToggle<cr>", desc = "Toggle Live Preview" },
      { "<leader>lr", "<cmd>LivePreviewRefresh<cr>", desc = "Refresh Live Preview" },
    },
  },
}
