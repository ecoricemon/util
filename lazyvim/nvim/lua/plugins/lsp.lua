return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Enable Deno
        denols = {},

        -- Enable TypeScript
        ts_ls = {},

        -- rustaceanvim will do this instead
        rust_analyzer = { enabled = false },

        -- flutter-tools will do this instead
        dartls = { enabled = false },
      },
      inlay_hints = { enabled = false },
      diagnostics = { virtual_text = false },
    },
  },
}
