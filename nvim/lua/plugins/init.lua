return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  {
    "NvChad/nvterm",
    config = function ()
      require("nvterm").setup({
        terminals = {
          shell = vim.o.shell,
          list = {},
          type_opts = {
            float = {
              relative = 'editor',
              row = 4.3,
              col = 4.25,
              width = 3.5,
              height = 3.4,
              border = "single",
            },
            horizontal = { location = "rightbelow", split_ratio = .3, },
            vertical = { location = "rightbelow", split_ratio = .5 },
          }
        },
        behavior = {
          autoclose_on_quit = {
            enabled = false,
            confirm = true,
          },
          close_on_exit = true,
          auto_insert = true,
        },
      })
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = { "clangd", "rust_analyzer" }
      }
    end
  },

  {
    "neovim/nvim-lspconfig",
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server", "stylua",
        "html-lsp", "css-lsp" , "prettier",
        "clangd", "rust-analyzer"
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "lua", "rust" },
      highlight = { enable = true },
    },
  },

  {
    "chaoren/vim-wordmotion",
    lazy = false,
  },

  {
    "folke/which-key.nvim",
    enabled = false
  },

  -- {
  --   "IogaMaster/neocord",
  --   event = "VeryLazy",
  --   config = {
  --     main_image = "language",
  --     show_time = true,
  --     workspace_text = function()
  --       return "using NvChad"
  --     end,
  --   },
  -- },

  {
    "nvzone/typr",
    dependencies = "nvzone/volt",
    opts = {},
    cmd = { "Typr", "TyprStats" },
  }
}
