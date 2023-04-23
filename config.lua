-- Colors
vim.cmd.colorscheme("sonokai")
-- other
vim.opt.clipboard = "unnamedplus"
-- line number
vim.opt.nu = true
vim.opt.relativenumber = true
-- scroll
vim.opt.scrolloff = 4
-- open panes
vim.opt.splitbelow = true
vim.opt.splitright = true
-- search
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- disable netrw for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1 

local function require_or_nil(module_name)
  local status, module = pcall(require, module_name)
  if status then
    return module
  end
  return nil
end

local function _require(module_name)
  local module = require_or_nil(module_name)
  if module then
    return module
  end
  local anyFunc = function(...) end
  return {setup = anyFunc, init = anyFunc, default_capabilities = anyFunc }
end

vim.o.timeout = true
vim.o.timeoutlen = 300
_require("which-key").setup {}
-- '<space>.' '<space>,' Swap siblings left and right
_require("sibling-swap").setup {}

-- theme switch
local adm = _require('auto-dark-mode')
adm.setup({
  	update_interval = 3000,
  	set_dark_mode = function()
  		vim.api.nvim_set_option('background', 'dark')
  		vim.cmd('colorscheme sonokai')
  	end,
  	set_light_mode = function()
  		vim.api.nvim_set_option('background', 'light')
  		vim.cmd('colorscheme solarized')
  	end,
  })
adm.init()

_require("telescope").setup{
  defaults = {
    mappings = {
      i = {
        ["<C-u>"] = false
      },
    },
  }
}
local telescope_builtin = require_or_nil('telescope.builtin')
if telescope_builtin then
  vim.keymap.set('n', '<C-p>', telescope_builtin.find_files, {})
  vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, {})
  vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, {})
  vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, {})
  vim.keymap.set('n', '<leader>ft', telescope_builtin.treesitter, {})
end

_require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "python" },
}
_require("nvim-tree").setup() 
vim.api.nvim_set_keymap('n', '<leader>ff', ":NvimTreeToggle<CR>", {noremap=true, silent=true})
_require("nvim-surround").setup({})

_require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
_require("mason").setup()

local cmp = require_or_nil('cmp')
if cmp then
  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })
end

local capabilities = _require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require_or_nil('lspconfig')
if lspconfig then
  lspconfig.pylsp.setup{capabilities=capabilities}
  lspconfig.tsserver.setup{capabilities=capabilities}
  lspconfig.lua_ls.setup{
    capabilities=capabilities,
    settings={
      Lua = {
        diagnostics = {globals={'vim'}}
      }
    }
  }
end
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

_require('Comment').setup()
_require('guess-indent').setup {}


-- packer installation
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  local Plug = use
  use 'wbthomason/packer.nvim'
  -- My plugins here
  use { 'sainnhe/sonokai' }
  use 'f-person/auto-dark-mode.nvim'
  use 'ishan9299/nvim-solarized-lua' 
  use 'nvim-tree/nvim-tree.lua'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
  -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use({
      "kylechui/nvim-surround",
      tag = "*", -- Use for stability; omit to use `main` branch for the latest features
  })
  use {
    "folke/which-key.nvim",
  }
  use {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
  }
  use {
      "williamboman/mason.nvim",
      run = ":MasonUpdate" -- :MasonUpdate updates registry contents
  }
  use 'neovim/nvim-lspconfig'
  -- gcc gcb
  use 'numToStr/Comment.nvim'
  use 'nmac427/guess-indent.nvim'
  use 'Wansmer/sibling-swap.nvim'
  -- View registers ""
  Plug 'gennaro-tedesco/nvim-peekup'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  -- TODO
  -- https://github.com/chrisgrieser/nvim-various-textobjs

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
