return {
  {
    "stevearc/conform.nvim",
    opts = { formatters_by_ft = { python = { "black" } } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function()
      Snacks.util.lsp.on({ name = "pylsp" }, function(_, client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end)
    end,
  },
}
