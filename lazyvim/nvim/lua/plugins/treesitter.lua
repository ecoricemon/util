return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- Ensure dart is NOT in the auto-install list
    if type(opts.ensure_installed) == "table" then
      opts.ensure_installed = vim.tbl_filter(function(lang)
        return lang ~= "dart"
      end, opts.ensure_installed)
    end

    -- Disable the modules for dart
    opts.highlight = opts.highlight or {}
    opts.highlight.disable = opts.highlight.disable or {}
    table.insert(opts.highlight.disable, "dart")

    opts.indent = opts.indent or {}
    opts.indent.disable = opts.indent.disable or {}
    table.insert(opts.indent.disable, "dart")
  end,
}
