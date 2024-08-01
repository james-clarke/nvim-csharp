-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Custom vim settings
vim.opt.number = true
vim.opt.relativenumber = true
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
vim.opt.wrap = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.ignorecase = true
vim.opt.shiftround = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.updatetime = 300
vim.opt.scrolloff = 999

-- Custom key-bindings
vim.keymap.set('n', '<Tab>', ':bnext<CR>')
vim.keymap.set('n', '<S-Tab>', ':bdelete<CR>')

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

-- Set mouse support
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
      -- mason.nvim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
    {
      -- omnisharp-extended-lsp.nvim
      "Hoffs/omnisharp-extended-lsp.nvim",
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
vim.keymap.set("n", "<leader>b", ":Neotree filesystem toggle right<CR>")

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
      package_uninstalled = "✗",
    },
  },
})

-- Setup for mason-lspconfig.nvim
require("mason-lspconfig").setup {
  ensure_installed = {
    "lua_ls",
    "omnisharp",
    "tsserver",
    "angularls",
    "html",
    "cssls",
  },
}

-- Setup for nvim-lspconfig.nvim
local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

lspconfig.lua_ls.setup {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT'
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        }
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      }
    }
  }
}
vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, {})
vim.keymap.set({'n', 'v'}, '<leader>dn', vim.diagnostic.open_float, {})

lspconfig.omnisharp.setup {
  settings = {
      FormattingOptions = {
        EnableEditorConfigSupport = true,
        OrganizeImports = nil,
      },
      MsBuild = {
        LoadProjectsOnDemand = nil,
      },
      RoslynExtensionsOptions = {
        EnableAnalyzersSupport = nil,
        EnableImportCompletion = nil,
        AnalyzeOpenDocumentsOnly = nil,
        -- Delete if issues arise
        EnableDecompilationSupport = true
      },
      Sdk = {
        IncludePrereleases = true,
      },
    },

    filetypes = { 'cs', 'vb' },
    root_dir = util.root_pattern('*.sln', '*.csproj', 'omnisharp.json', 'function.json'),
    on_new_config = function(new_config, _)
      new_config.cmd = { unpack(new_config.cmd or {}) }

      table.insert(new_config.cmd, '-z') -- https://github.com/OmniSharp/omnisharp-vscode/pull/4300
      vim.list_extend(new_config.cmd, { '--hostPID', tostring(vim.fn.getpid()) })
      table.insert(new_config.cmd, 'DotNet:enablePackageRestore=false')
      vim.list_extend(new_config.cmd, { '--encoding', 'utf-8' })
      table.insert(new_config.cmd, '--languageserver')

      local function flatten(tbl)
        local ret = {}
        for k, v in pairs(tbl) do
          if type(v) == 'table' then
            for _, pair in ipairs(flatten(v)) do
              ret[#ret + 1] = k .. ':' .. pair
            end
          else
            ret[#ret + 1] = k .. '=' .. vim.inspect(v)
          end
        end
        return ret
      end
      if new_config.settings then
        vim.list_extend(new_config.cmd, flatten(new_config.settings))
      end

      new_config.capabilities = vim.deepcopy(new_config.capabilities)
      new_config.capabilities.workspace.workspaceFolders = false -- https://github.com/OmniSharp/omnisharp-roslyn/issues/909
    end,
    init_options = {},
}

-- Keymaps for omnisharp-extended-lsp
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', 'gr', "<cmd>lua require('omnisharp_extended').telescope_lsp_references()<cr>", opts)
vim.api.nvim_set_keymap('n', 'gd', "<cmd>lua require('omnisharp_extended').telescope_lsp_definition({ jump_type = 'vsplit' })<cr>", opts)
vim.api.nvim_set_keymap('n', '<leader>D', "<cmd>lua require('omnisharp_extended').telescope_lsp_type_definition()<cr>", opts)
vim.api.nvim_set_keymap('n', 'gi', "<cmd>lua require('omnisharp_extended').telescope_lsp_implementation()<cr>", opts)
-- vim.api.nvim_set_keymap('n', '<leader>f', "<cmd>lua require('omnisharp_extended').telescope_lsp_formatting()<CR>", opts)

lspconfig.tsserver.setup{}

local dev_path = "~/Developer/"
lspconfig.angularls.setup{
  cmd = {"ngserver", "--stdio", "--tsProbeLocations", dev_path, "--ngProbeLocations", dev_path},
  on_new_config = function(new_config,new_root_dir)
    new_config.cmd = {"ngserver", "--stdio", "--tsProbeLocations", dev_path, "--ngProbeLocations", dev_path}
  end,
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.html.setup{
  capabilities = capabilities,
}

lspconfig.cssls.setup{
  capabilities = capabilities,
}

