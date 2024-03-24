return {
  -- Toggle term from https://github.com/akinsho/toggleterm.nvim
  { 
    "akinsho/toggleterm.nvim", 
    version = "2.10.0",
    keys = {
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float" },
      { "<leader>tv", "<cmd>ToggleTerm size=80 dir=~/Desktop direction=vertical<cr>", desc = "Split vertical" },
      { "<leader>th", "<cmd>ToggleTerm size=20 dir=~/Desktop direction=horizontal<cr>", desc = "Split horizontal" }, 
    },
    opts = {
      hide_numbers = true,
      autochdir = false,
      close_on_exit = true,
      auto_scroll = true,
    },
  },

  -- Rust setting from http://www.lazyvim.org/extras/lang/rust
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        opts = {
          src = {
            cmp = { enabled = true },
          },
        },
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, { name = "crates" })
    end,
  },

  -- Rust setting from http://www.lazyvim.org/extras/lang/rust
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      src = {
        cmp = { enabled = true },
      },
    },
  },

  -- Rust setting from http://www.lazyvim.org/extras/lang/rust
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "ron", "rust", "toml" })
    end,
  },

  -- Rust setting from http://www.lazyvim.org/extras/lang/rust
  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
    opts = {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>cR", function()
            vim.cmd.RustLsp("codeAction")
          end, { desc = "Code Action", buffer = bufnr })
          vim.keymap.set("n", "<leader>dr", function()
            vim.cmd.RustLsp("debuggables")
          end, { desc = "Rust debuggables", buffer = bufnr })
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            -- Add clippy lints for Rust.
            checkOnSave = {
              allFeatures = true,
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },

  -- Rust setting from http://www.lazyvim.org/extras/lang/rust
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {},
        taplo = {
          keys = {
            {
              "K",
              function()
                if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                  require("crates").show_popup()
                else
                  vim.lsp.buf.hover()
                end
              end,
              desc = "Show Crate Documentation",
            },
          },
        },
      },
      setup = {
        rust_analyzer = function()
          return true
        end,
      },
    },
  },

  --
  -- {
  --   "simrat39/rust-tools.nvim",
  --   config = function()
  --     local rt = require("rust-tools")
  --     rt.setup({
  --       server = {
  --         on_attach = function(_, bufnr)
  --           -- Hover actions
  --           vim.keymap.set("n", "<leader>rh", rt.hover_actions.hover_actions,
  --             { buffer = bufnr, desc = "Hover action" })
  --           -- Code action groups
  --           vim.keymap.set("n", "<leader>rc", rt.code_action_group.code_action_group,
  --             { buffer = bufnr, desc = "Code action" })
  --         end,
  --       },
  --     })
  --     -- Just group <leader>rh and <leader>rc into <leader>r
  --     local wk = require("which-key")
  --     wk.register({
  --       r = {
  --         name = "Plugin: rust-tools"
  --       },
  --     }, { prefix = "<leader>" })
  --   end,
  -- },
}
