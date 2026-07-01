local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    go = { "goimports" },
    python = { "ruff" },
    terraform = { "terraform" },
    tf = { "terraform" },
    ts = { "prettierd" },
    ["terraform-vars"] = { "terraform" }
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
