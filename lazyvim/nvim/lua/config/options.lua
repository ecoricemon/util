-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable all snacks.nvim animations
vim.g.snacks_animate = false

-- Disable some default styles, which will be overridden by after/
vim.g.rust_recommended_style = 0

-- Disable auto formatting
vim.g.autoformat = false

-- Enable text wrapping
vim.opt.wrap = true

-- Disable hiding syntax elements like ```rust in markdown files
vim.opt.conceallevel = 0

-- Disable relative number
vim.opt.relativenumber = false

-- Send yanked text directly to OS clipboard
vim.opt.clipboard = "unnamedplus"
