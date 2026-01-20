-- lua/plugins/yaml.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              customTags = {
                "!fn",
                "!And",
                "!If",
                "!Not",
                "!Equals",
                "!Or",
                "!FindInMap sequence",
                "!Base64",
                "!Cidr",
                "!Ref",
                "!Ref Scalar",
                "!Sub",
                "!Sub sequence",
                "!GetAtt",
                "!GetAZs",
                "!ImportValue",
                "!Select",
                "!Select sequence",
                "!Split",
                "!Join sequence",
              },
            },
          },
        },
      },
    },
  },
}
