return {
  {
    "mrcjkb/rustaceanvim",
    version = "^8",
    lazy = false,
    ft = { "rust" },
    init = function()
      local mason = vim.fn.stdpath("data") .. "/mason"
      local codelldb = mason .. "/bin/codelldb"
      local liblldb = mason .. "/packages/codelldb/extension/lldb/lib/liblldb.dylib"

      vim.g.rustaceanvim = {
        dap = {
          adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb, liblldb),
        },
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = false,
              check = { command = "check" }, -- even check could be too slow
            },
          },
          on_attach = function(_, bufnr)
            vim.keymap.set("n", "<leader>dr", function()
              vim.cmd.RustLsp("debuggables")
            end, { buffer = bufnr, desc = "Rust Debuggables" })
            vim.keymap.set("n", "<leader>k", function()
              vim.cmd("silent! wa") -- Saves all changed buffers silently
              vim.cmd.RustLsp("flyCheck")
            end, { buffer = bufnr, desc = "Save all & FlyCheck" })
          end,
        },
      }
    end,
  },
  -- Override "mini.pairs"
  {
    'nvim-mini/mini.pairs',
    version = '*',
    opts = {
      mappings = {
        -- Disable pairing ' '
        ["'"] = false,
      }
    }
  }
}
