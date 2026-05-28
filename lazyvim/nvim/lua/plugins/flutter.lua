return {
  "nvim-flutter/flutter-tools.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim", -- optional for better UI
  },
  config = function()
    require("flutter-tools").setup({
      lsp = {
        color = {
          enabled = true, -- Shows color squares for Colors.blue etc.
        },
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          renameFilesWithClasses = "always", -- Automatic refactoring
          enableSnippets = true,
        },
      },
      widget_guides = { enabled = true }, -- The vertical lines in your UI code
    })
  end,
}
