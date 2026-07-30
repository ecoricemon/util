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
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          renameFilesWithClasses = "always", -- Automatic refactoring
          enableSnippets = true,
        },
      },
      widget_guides = { enabled = true }, -- The vertical lines in your UI code
    })

    -- On Neovim 0.12+, use the built-in LSP document color support instead
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(ev)
        vim.lsp.document_color.enable(true, { bufnr = ev.buf })
      end,
    })
  end,
}
