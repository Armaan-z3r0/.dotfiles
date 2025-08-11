return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "b0o/schemastore.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      
      -- Simplified diagnostic configuration
      vim.diagnostic.config({
        virtual_text = { prefix = "●", spacing = 2 },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
      })
      
      -- Set diagnostic signs (modern API)
      local signs = { Error = "", Warn = "", Hint = "", Info = "" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.diagnostic.config({
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = signs.Error,
              [vim.diagnostic.severity.WARN] = signs.Warn,
              [vim.diagnostic.severity.INFO] = signs.Info,
              [vim.diagnostic.severity.HINT] = signs.Hint,
            }
          }
        })
      end
      
      -- Reusable on_attach function with your keybinds
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, silent = true }
        -- Your existing keybinds (preserved)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
      end
      
      -- Common LSP setup function
      local function setup_lsp(server, config)
        config = config or {}
        config.capabilities = capabilities
        config.on_attach = on_attach
        lspconfig[server].setup(config)
      end
      
      -- LSP Server configurations
      setup_lsp("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = { 
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false 
            },
            telemetry = { enable = false },
          },
        },
      })
      
      setup_lsp("ts_ls", {
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "json" },
        root_dir = lspconfig.util.root_pattern("next.config.js", "package.json", "tsconfig.json", ".git"),
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
            },
          },
        },
      })
      
      setup_lsp("pyright", {
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              typeCheckingMode = "basic",
            },
          },
        },
      })
      
      setup_lsp("tailwindcss", {
        filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
        root_dir = lspconfig.util.root_pattern("tailwind.config.js", "tailwind.config.ts", "package.json"),
      })
      
      setup_lsp("jsonls", {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      })
      
      -- Simple servers (no special config needed)
      local simple_servers = { "html", "cssls", "bashls" }
      for _, server in ipairs(simple_servers) do
        setup_lsp(server)
      end
    end,
  },
  
  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        -- Your existing keybinds (preserved)
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-k>'] = cmp.mapping.select_prev_item(),
        }),
        window = {
          completion = { max_height = 8, max_width = 60, border = "rounded" },
          documentation = { max_height = 10, max_width = 80, border = "rounded" },
        },
        sources = cmp.config.sources({
          { name = 'codeium', priority = 1000, max_item_count = 3 },
          { name = 'nvim_lsp', priority = 900, max_item_count = 8 },
          { name = 'luasnip', priority = 800, max_item_count = 5 },
        }, {
          { name = 'buffer', keyword_length = 3, max_item_count = 3 },
          { name = 'path', max_item_count = 5 },
        }),
        formatting = {
          format = function(entry, vim_item)
            local icons = {
              nvim_lsp = "[LSP]",
              luasnip = "[Snip]",
              codeium = "[AI]",
              buffer = "[Buf]",
              path = "[Path]",
            }
            vim_item.menu = icons[entry.source.name]
            
            -- Truncate long items
            if #vim_item.abbr > 50 then
              vim_item.abbr = vim_item.abbr:sub(1, 47) .. "..."
            end
            
            return vim_item
          end,
        },
      })
      
      -- Command line completion
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {{ name = 'buffer' }}
      })
      
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({{ name = 'path' }}, {{ name = 'cmdline' }})
      })
    end,
  },
  
  -- AI Completion
  --[[
  {
    "Exafunction/codeium.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "hrsh7th/nvim-cmp" },
    event = "BufEnter",
    config = function()
      require("codeium").setup({
        enable_chat = true,
        virtual_text = {
          enabled = true,
          key_bindings = {
            -- Your existing keybinds (preserved)
            accept = "<C-g>",
            accept_word = "<C-Right>",
            accept_line = "<C-Down>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          }
        },
      })
    end,
  ---]]
   }
