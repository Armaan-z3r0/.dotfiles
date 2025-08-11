-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)

-- Set leader key first
vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details-.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
})

-- Better Window Navigation
vim.keymap.set("n", "<C-h>", "<C-w>h") -- Move left
vim.keymap.set("n", "<C-l>", "<C-w>l") -- Move right
vim.keymap.set("n", "<C-j>", "<C-w>j") -- Move down
vim.keymap.set("n", "<C-k>", "<C-w>k") -- Move up
-- Easy Escape in Insert Mode
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("i", "jj", "<Esc>")

-- Fast Saving & Quitting
vim.keymap.set("n", "<C-s>", ":w<CR>")       -- Save
vim.keymap.set("n", "<leader>q", ":q<CR>")   -- Quit
vim.keymap.set("n", "<leader>x", ":x<CR>")   -- Save & Quit
vim.keymap.set("n", "<leader>Q", ":qa!<CR>") -- Force Quit

-- Better Copy & Paste
vim.opt.clipboard = "unnamedplus"       -- Use system clipboard
vim.keymap.set("v", "<leader>y", '"+y') -- Copy to system clipboard
vim.keymap.set("n", "<leader>p", '"+p') -- Paste from system clipboard

-- Fast Navigation in Files
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- Scroll half page down
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- Scroll half page up
vim.keymap.set("n", "n", "nzzzv")       -- Keep search results centered
vim.keymap.set("n", "N", "Nzzzv")

-- Keep Cursor in Place While Joining Lines vim.keymap.set("n", "J", "mzJ`z")

-- Clear Search Highlights
vim.keymap.set("n", "<leader>h", ":noh<CR>")

vim.opt.colorcolumn = "120"

vim.opt.wrap = true -- Enable line wrapping
vim.opt.linebreak = true -- Wrap at word boundaries instead of cutting words
vim.opt.breakindent = true -- Maintain indentation when wrapping

vim.opt.showbreak = "↪ " -- Add a symbol to indicate wrapped lines

vim.opt.number = true -- Show absolute number on the current line
vim.opt.relativenumber = true -- Show relative numbers on other lines


vim.opt.tabstop = 2      -- Set tab width to 4 spaces
vim.opt.shiftwidth = 2   -- Set indentation width to 4 spaces
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.softtabstop = 2  -- Insert 4 spaces when pressing Tab

local opts = { noremap = true, silent = true }

-- Next buffer
vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)

-- Previous buffer
vim.keymap.set("n", "<S-Tab>", ":bprev<CR>", opts)

-- List all buffers
vim.keymap.set("n", "<leader>bl", ":ls<CR>", opts)

-- (Optional) Pick a buffer after listing
vim.keymap.set("n", "<leader>bb", ":b<Space>", { noremap = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

