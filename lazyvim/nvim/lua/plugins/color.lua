return {
  {
    "rose-pine/neovim",
    priority = 1000,
    lazy = false,
    config = function()
      require("rose-pine").setup({
        variant = "dawn",
        before_highlight = function(group, highlight, palette)
          -- ea9d34 -> darker
          if highlight.fg == palette.gold then
              highlight.fg = '#c1822c'
          end
        end,
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
}
