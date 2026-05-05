-- Customize Mason

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        -- install language servers (moved from init.lua for v6)
        "lua-language-server",
        "powershell-editor-services",
        "pyright",
        "json-lsp",
        "yaml-language-server",
        "bash-language-server",
        "vim-language-server",
        "typescript-language-server",
        "graphql-language-service-cli",

        -- install formatters
        "stylua",
        "prettierd",

        -- install debuggers
        "debugpy",

        -- install linters and other tools
        "tree-sitter-cli",
        "eslint_d",
      },
    },
  },
}
