return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })()
        end,
	      config = function()
        require("nvim-treesitter.configs").setup({
                ensure_installed = { "lua", "python", "javascript", "html", "css", "bash", "c" ,"tsx","typescript"}, -- Add languages you use
                sync_install = false, -- Install parsers asynchronously
                highlight = { enable = true }, -- Enable syntax highlighting
                indent = { enable = true }, -- Enable automatic indentation
		            incremental_selection = {
			enable = true,
			keymaps = {
		        	init_selection = "gnn",         -- Start incremental selection
	        		node_incremental = "grn",       -- Expand selection to the next node
	        		scope_incremental = "grc",      -- Expand selection to the next scope (function, block, etc.)
	        		node_decremental = "grm",       -- Shrink selection
	    		},
		},

             })
        end,
    }
}

