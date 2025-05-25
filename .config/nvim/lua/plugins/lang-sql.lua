return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sqls = {
          settings = {
            sqls = {
              connections = {
                {
                  driver = "mysql",
                  dataSourceName = "root:@tcp(127.0.0.1:3306)/",
                },
              },
            },
          },
        },
      },
    },
  },
}
