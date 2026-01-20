-- lua/plugins/lang-php.lua
return {
  -- WordPress-specific Intelephense configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {
          settings = {
            intelephense = {
              files = {
                maxSize = 5000000,
              },
              environment = {
                phpVersion = "8.2",
              },
              format = {
                braces = "k&r",
              },
              completion = {
                insertUseDeclaration = true,
                fullyQualifyGlobalConstantsAndFunctions = true,
              },
              diagnostics = {
                undefinedTypes = true,
                undefinedFunctions = true,
                undefinedConstants = true,
                undefinedProperties = true,
                undefinedMethods = true,
              },
              stubs = {
                -- WordPress-specific stubs (add to defaults)
                "wordpress",
                "woocommerce",
                "phpunit",
              },
            },
          },
        },
      },
    },
  },

  -- WordPress Xdebug configuration
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")

      -- Ensure php adapter exists (installed via Mason as php-debug-adapter)
      if not dap.adapters.php then
        dap.adapters.php = {
          type = "executable",
          command = "node",
          args = {
            vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js",
          },
        }
      end

      -- WordPress-specific debug configurations
      dap.configurations.php = dap.configurations.php or {}
      vim.list_extend(dap.configurations.php, {
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug",
          port = 9003,
          pathMappings = {
            ["/var/www/html"] = "${workspaceFolder}",
          },
        },
        {
          type = "php",
          request = "launch",
          name = "Launch PHP Script",
          program = "${file}",
          cwd = "${fileDirname}",
          port = 9003,
        },
        {
          type = "php",
          request = "launch",
          name = "Launch WordPress",
          port = 9003,
          serverSourceRoot = "/var/www/html",
          localSourceRoot = "${workspaceFolder}",
        },
      })
    end,
  },

  -- PHPUnit test configuration
  {
    "nvim-neotest/neotest",
    optional = true,
    opts = {
      adapters = {
        ["neotest-phpunit"] = {
          phpunit_cmd = function()
            return "vendor/bin/phpunit"
          end,
        },
      },
    },
  },
}
