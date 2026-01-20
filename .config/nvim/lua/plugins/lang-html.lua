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
              hover = { documentation = true, references = true },
              completion = { attributeDefaultValue = "doublequotes" },
              validate = { scripts = true, styles = true },
            },
          },
        },
        emmet_ls = {
          filetypes = {
            "html",
            "css",
            "scss",
            "javascript",
            "typescript",
            "htmldjango",
            "vue",
            "svelte",
            "php",
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
      -- Modern config structure
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
      },
      -- Ensure PHP and XML are covered
      per_filetype = {
        ["php"] = { enable_close = true },
        ["xml"] = { enable_close = true },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "html-lsp", "emmet-ls" })
    end,
  },
}
