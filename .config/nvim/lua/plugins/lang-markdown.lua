return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          settings = {
            markdown = {
              formatter = {
                formatOnSave = true,
              },
              validation = {
                enabled = true,
              },
              lint = {
                enabled = true,
              },
              extension = {
                toc = {
                  enabled = true,
                  levels = "2..6",
                },
                list = {
                  enabled = true,
                  autoNumbering = true,
                },
                syntax = {
                  enabled = true,
                  multiline = true,
                  codeBlock = true,
                  math = true,
                },
              },
            },
          },
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "marksman")
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" }, wait = true })
    end,
    cmd = {
      "MarkdownPreview",
      "MarkdownPreviewStop",
      "MarkdownPreviewToggle",
    },
    ft = { "markdown" },
  },
}
