-- lua/plugins/lang-xml.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lemminx = {
          settings = {
            xml = {
              format = {
                enabled = true,
                splitAttributes = true,
                joinCDATALines = false,
                joinContentLines = false,
                joinCommentLines = false,
                spaceBeforeEmptyCloseTag = true,
                preserveEmptyContent = false,
              },
              validation = {
                enabled = true,
                schema = true,
                noGrammar = "hint",
              },
              server = {
                workDir = ".lemminx",
              },
              completion = {
                autoCloseTags = true,
              },
            },
          },
        },
      },
    },
  },
}
