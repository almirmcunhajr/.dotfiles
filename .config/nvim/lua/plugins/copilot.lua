return {
  "github/copilot.vim",
  lazy = false,
  init = function()
    vim.g.copilot_no_tab_map = true
  end,
  config = function()
    vim.keymap.set("i", "<C-y>", 'copilot#Accept("")', { expr = true, replace_keycodes = false })
    vim.keymap.set("i", "<M-f>", "<Plug>(copilot-accept-word)")
  end,
}
