vim.keymap.set({ "n", "v" }, "<leader>cf", function()
  local ft = vim.bo.filetype
  if ft == "javascriptreact" or ft == "typescriptreact" then
    vim.lsp.buf.format({ async = true })
  else
    require("conform").format({ async = true })
  end
end)

return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      python = { "black" }
    }
  }
}
