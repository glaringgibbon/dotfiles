-- lua/plugins/tool-toml.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        taplo = {
          settings = {
            toml = {
              formatting = {
                alignEntries = true,
                alignComments = true,
                columnWidth = 80,
                reorderKeys = false,
                indentTables = true,
                indentEntries = true,
              },
              schema = {
                enabled = true,
                repositoryEnabled = true,
                repositoryUrl = "https://taplo.tamasfe.dev/schema_index.json",
              },
              validation = {
                enabled = true,
                arraySpacing = true,
                indentation = true,
                keyValueSpacing = true,
              },
            },
          },
        },
      },
    },
  },
}
