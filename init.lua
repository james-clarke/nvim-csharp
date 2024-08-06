-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Custom vim settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.background = "dark"
vim.opt.termguicolors = true
vim.opt.backspace = '2'
vim.opt.showcmd = true
vim.opt.laststatus = 4
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
vim.opt.scrolloff = 12

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
vim.g.maplocalleader = " "

-- Set mouse support
vim.o.mouse = 'a'

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        {
            -- Setup for gruvbox.nvim
            "ellisonleao/gruvbox.nvim",
            priority = 1000,
            lazy = false,
            config = function()
                require("gruvbox").setup({
                    italic = { strings = false },
                    contrast = "soft",
                })
                vim.cmd("colorscheme gruvbox")
            end
        },
        {
            "nvim-telescope/telescope-ui-select.nvim"
        },
        {
            -- Setup for telescope.nvim
            'nvim-telescope/telescope.nvim',
            tag = '0.1.8',
            dependencies = { 'nvim-lua/plenary.nvim' },
            config = function()
                require("telescope").setup({
                    pickers = {
                        find_files = { hidden = true }
                    },
                    extensions = {
                        ["ui-select"] = {
                            require("telescope.themes").get_dropdown({}),
                        },
                    },
                })
                local builtin = require('telescope.builtin')
                vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
                vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
                vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
                vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
                require("telescope").load_extension("ui-select")
            end
        },
        {
            -- Setup for treesitter.nvim
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            config = function()
                require("nvim-treesitter.configs").setup({
                    ensure_installed = { "c_sharp", "lua", "javascript", "html", "css" },
                    auto_install = true,
                    highlight = { enable = true },
                    indent = { enable = true },
                })
            end
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
            config = function()
                require("neo-tree").setup({
                    filesystem = {
                        filtered_items = {
                            visible = true,
                            hide_dotfiles = false,
                            hide_gitignored = false,
                            hide_by_name = {
                            },
                            never_show = {},
                        },
                    },
                })
                vim.keymap.set("n", "<leader>b", ":Neotree filesystem toggle right<CR>")
            end
        },
        {
            -- lualine.nvim
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons' },
            config = function()
                require("lualine").setup({
                    options = { theme = "gruvbox" },
                })
            end
        },
        {
            -- Setup for mason.nvim
            "williamboman/mason.nvim",
            config = function()
                require("mason").setup({
                    ui = {
                        icons = {
                            package_installed = "✓",
                            package_pending = "➜",
                            package_uninstalled = "✗",
                        },
                    },
                })
            end
        },
        {
            -- Setup for mason-lspconfig.nvim
            "williamboman/mason-lspconfig.nvim",
            config = function()
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
            end
        },
        {
            -- Setup for omnisharp-extended-lsp.nvim
            "Hoffs/omnisharp-extended-lsp.nvim",
        },
        {
            -- Setup for nvim-lspconfig
            "neovim/nvim-lspconfig",
            config = function()
                -- local variables for lsp-config.nvim
                local lspconfig = require("lspconfig")
                local util = require("lspconfig.util")
                local capabilities = vim.lsp.protocol.make_client_capabilities()

                -- lua_ls
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
                                }
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

                -- omnisharp
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

                -- keymaps for omnisharp-extended-lsp
                local opts = {
                    noremap = true,
                    silent = true
                }

                vim.api.nvim_set_keymap('n', 'gr', "<cmd>lua require('omnisharp_extended').telescope_lsp_references()<cr>", opts)
                vim.api.nvim_set_keymap('n', 'gd', "<cmd>lua require('omnisharp_extended').telescope_lsp_definition({ jump_type = 'vsplit' })<cr>", opts)
                vim.api.nvim_set_keymap('n', '<leader>D', "<cmd>lua require('omnisharp_extended').telescope_lsp_type_definition()<cr>", opts)
                vim.api.nvim_set_keymap('n', 'gi', "<cmd>lua require('omnisharp_extended').telescope_lsp_implementation()<cr>", opts)

                -- tsserver
                lspconfig.tsserver.setup{}

                -- angularls
                local dev_path = "~/Developer/"
                lspconfig.angularls.setup{
                    cmd = {"ngserver", "--stdio", "--tsProbeLocations", dev_path, "--ngProbeLocations", dev_path},
                    on_new_config = function(new_config,new_root_dir)
                        new_config.cmd = {"ngserver", "--stdio", "--tsProbeLocations", dev_path, "--ngProbeLocations", dev_path}
                    end,
                }

                -- html
                capabilities.textDocument.completion.completionItem.snippetSupport = true
                lspconfig.html.setup{
                    capabilities = capabilities,
                }

                -- cssls
                lspconfig.cssls.setup{
                    capabilities = capabilities,
                }
            end
        },
        {
            "vimtools/none-ls.nvim",
            config = function()
                local null_ls = require("null-ls")
                null_ls.setup({
                    sources = {
                        null_ls.builtins.formatting.stylua,
                        null_ls.builtins.completion.spell,
                        require("none-ls.diagnostics.eslint"),
                    },
                })
            end
        },
    },
    -- Automatically check for plugin updates
    checker = { enabled = true },
})


-- Global key-bindings
vim.keymap.set('n', '<Tab>', ':bnext<CR>')
vim.keymap.set('n', '<S-Tab>', ':bdelete<CR>')
vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, {})
vim.keymap.set({'n', 'v'}, '<leader>dn', vim.diagnostic.open_float, {})

