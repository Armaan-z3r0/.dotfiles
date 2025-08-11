--[[return {
  
  "Exafunction/codeium.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    require("codeium").setup({
      -- Enable auto-completion integration with nvim-cmp
      enable_chat = true,
      -- Configure the virtual text (inline suggestions)
      virtual_text = {
        enabled = true,
        manual = false, -- Set to true if you want manual triggering
        map_keys = true,
        key_bindings = {
          accept = "<Tab>",
          accept_word = "<C-Right>",
          accept_line = "<C-Down>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        }
      },
      -- Tools configuration
      tools = {
        curl = "curl",
        gzip = "gzip",
        uname = "uname",
        uuidgen = "uuidgen",
      }
    })

    -- Add codeium source to nvim-cmp
    local cmp = require('cmp')
    local config = cmp.get_config()

    -- Insert codeium source at the beginning for higher priority
    table.insert(config.sources, 1, {
      name = "codeium",
      priority = 1500,    -- Higher than LSP
      max_item_count = 3, -- Limit suggestions to avoid clutter
    })

    -- Update the cmp configuration
    cmp.setup(config)
  end,
  event = "BufEnter",
}--]]
return {

}
