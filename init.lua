-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Custom vim settings
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.background = "dark"
vim.opt.termguicolors = true
vim.opt.backspace = '2'
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true
vim.o.shiftround = true
vim.o.clipboard = 'unnamedplus'
vim.o.updatetime = 300

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Set mapleader and maplocalleader before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- Set mouse to true
vim.o.mouse = 'a'

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Define plugins here
    {
      -- gruvbox.nvim
      "ellisonleao/gruvbox.nvim",
      priority = 1000,
    },
    {
      -- telescope.nvim
      'nvim-telescope/telescope.nvim',
      tag = '0.1.8',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
      -- treesitter.nvim
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
    },
    {
      -- neotree.nvim
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
    },
    {
      -- lualine.nvim
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
  },
  -- Automatically check for plugin updates
  checker = { enabled = true },
})

-- Setup gruvbox.nvim
require("gruvbox").setup({
  italic = {
    strings = false,
  },
  contrast = "soft",
})
vim.cmd("colorscheme gruvbox")

-- Setup for telescope.nvim
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Setup for treesitter.nvim
local configs = require("nvim-treesitter.configs")
configs.setup({
  ensure_installed = { "c_sharp", "lua", "javascript", "html", "css" },
  highlight = { enable = true },
  indent = { enable = true },
})

-- Setup for neotree.nvim
vim.keymap.set("n", "<C-b>", ":Neotree filesystem toggle right<CR>")

-- Setup for lualine.nvim
require("lualine").setup({
  options = { theme = "gruvbox" },
})

-- Setup for mason.nvim
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

-- Setup for mason-lspconfig.nvim
require("mason-lspconfig").setup {
  ensure_installed = { "lua_ls", "omnisharp", "tsserver", "angularls", "html", "cssls" },
}

-- Setup for nvim-lspconfig.nvim
local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup {
  settings = {
    ['Lua'] = {
      diagnostics = {
        globals = { 'vim' }
      }
    },
  },
}

