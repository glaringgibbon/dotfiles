-- lua/plugins/tool-colorizer.lua
return {
  "norcalli/nvim-colorizer.lua",
  event = "BufReadPre",
  config = function()
    require("colorizer").setup({
      "css",
      "scss",
      "sass",
      "html",
      "javascript",
      "lua",
    }, {
      RGB = true,
      RRGGBB = true,
      names = true,
      RRGGBBAA = true,
      mode = "background",
    })
  end,
}
