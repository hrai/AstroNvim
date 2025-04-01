-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      -- add more arguments for adding more treesitter parsers
    },
    highlight = {
      enable = true,
      -- disable treesitter for large files
      disable = function(lang, bufnr) --
        -- Extend this to other languages by adding `lang == "x"` where x is the language
        return vim.api.nvim_buf_line_count(bufnr) > 10000 and (lang == "cpp" or lang == "c" or lang == "csv")
      end,
      additional_vim_regex_highlighting = false,
    },
  },
}
