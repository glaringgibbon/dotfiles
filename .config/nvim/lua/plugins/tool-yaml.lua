-- lua/plugins/tool-yaml.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
              format = {
                enable = true,
                singleQuote = false,
                bracketSpacing = true,
              },
              validate = true,
              schemaStore = {
                enable = true,
                url = "https://www.schemastore.org/api/json/catalog.json",
              },
              schemas = {
                ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
                ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
                ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
                ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                ["http://json.schemastore.org/docker-compose"] = "docker-compose.{yml,yaml}",
                ["http://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
                ["http://json.schemastore.org/kubernetes"] = "kubernetes/*.{yml,yaml}",
              },
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
