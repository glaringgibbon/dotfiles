-- lua/plugins/lang-html.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {
          filetypes = { "html", "htmldjango" },
          settings = {
            html = {
              format = {
                indentInnerHtml = true,
                templating = true,
                wrapLineLength = 120,
              },
              hover = {
                documentation = true,
                references = true,
              },
              completion = {
                attributeDefaultValue = "doublequotes",
              },
              validate = {
                scripts = true,
                styles = true,
              },
            },
          },
        },
        emmet_ls = {
          filetypes = {
            "html",
            "css",
            "scss",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "htmldjango",
            "vue",
            "svelte",
          },
          init_options = {
            html = {
              options = {
                ["bem.enabled"] = true,
                ["jsx.enabled"] = true,
              },
            },
          },
        },
      },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    opts = {
      autotag = {
        enable = true,
        filetypes = {
          "html",
          "xml",
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
          "svelte",
          "vue",
          "tsx",
          "jsx",
          "rescript",
          "php",
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "emmet-ls")
      table.insert(opts.ensure_installed, "html-lsp")
    end,
  },
}
