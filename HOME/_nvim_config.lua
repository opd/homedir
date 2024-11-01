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
vim.keymap.set('n', '<F7>', 'Oimport pdb;pdb.set_trace()<Esc>')
vim.cmd.cnoreabbrev(
  {"PlugInstall", "PackerInstall"}
)

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


local gitlinker = require_or_nil('gitlinker')
if gitlinker then
  gitlinker.setup()
end

vim.api.nvim_create_user_command('Ag',
  function(opts)
    _require('telescope.builtin').live_grep(
      {default_text=opts.fargs[1]}
    )
  end,
  { nargs = 1 }
)

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

local lga_actions = _require("telescope-live-grep-args.actions")
local telescope = require_or_nil("telescope")
if telescope then
  telescope.setup{
    defaults = {
      mappings = {
        i = {
          ["<C-u>"] = false
        },
      },
      vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          -- '--hidden',
      },
    },
    extensions = {
      live_grep_args = {
        auto_quoting = true, -- enable/disable auto-quoting
        -- define mappings, e.g.
        mappings = { -- extend mappings
          i = {
            ["<C-k>"] = lga_actions.quote_prompt(),
            ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
          },
        },
        find_command = {"rg"},
        -- ... also accepts theme settings, for example:
        -- theme = "dropdown", -- use dropdown theme
        -- theme = { }, -- use own theme spec
        -- layout_config = { mirror=true }, -- mirror preview pane
      }
    },
  }
  telescope.load_extension("live_grep_args")
end

local live_grep_args_shortcuts = require_or_nil("telescope-live-grep-args.shortcuts")
if live_grep_args_shortcuts then
  vim.keymap.set('n', '<leader>fg', live_grep_args_shortcuts.grep_word_under_cursor)
end

local telescope_builtin = require_or_nil('telescope.builtin')
if telescope_builtin then
  vim.keymap.set('n', '<C-p>', telescope_builtin.find_files, {})
  -- vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, {})
  -- vim.keymap.set('n', '<leader>fg', telescope.extensions.live_grep_args.live_grep_args, {})
  vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, {})
  vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, {})
  vim.keymap.set('n', '<leader>ft', telescope_builtin.treesitter, {})
end

_require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "python" },
}
_require("nvim-tree").setup() 
-- vim.api.nvim_set_keymap('n', '<leader>ff', ":NvimTreeToggle<CR>", {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>ff', ":RnvimrToggle<CR>", {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>fc', ":HopChar1<CR>", {noremap=true, silent=true})
vim.g.rnvimr_draw_border = 1
_require("nvim-surround").setup({})

_require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
_require("mason").setup()
_require("various-textobjs").setup({ useDefaultKeymaps = true })

-- SNIPPET SETUP
local luasnip = require_or_nil('luasnip')
-- Setup my snippets
_require("snippets").setup(luasnip)
-- press <Tab> to expand or jump in a snippet. These can also be mapped separately
-- via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
vim.cmd("imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'")
-- -1 for jumping backwards.
vim.cmd("inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>")
vim.cmd("snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr)>")
vim.cmd("snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr)>")
-- For changing choices in choiceNodes (not strictly necessary for a basic setup).
vim.cmd("imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>)'")
vim.cmd("smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>)'")


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
  -- lspconfig.pylsp.setup{capabilities=capabilities}
  lspconfig.pyright.setup{capabilities=capabilities}
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
    'nvim-telescope/telescope.nvim', tag = '0.1.4',
  -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use 'L3MON4D3/LuaSnip'
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
    'mg979/vim-visual-multi',
    branch = 'master',
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
  -- crs snake_case
  -- crm MixedCase
  -- crc camelCase
  -- cru UPPER_CASE
  -- cr- dash-case
  -- cr. dot.case
  -- cr<space> space case
  -- crt Title Case
  Plug 'tpope/vim-abolish'
  -- aS: subword
  -- ii: lines with same or higher identation
  Plug 'chrisgrieser/nvim-various-textobjs'
  Plug 'kevinhwang91/rnvimr'
  Plug 'f-person/git-blame.nvim'
  Plug 'nvim-telescope/telescope-live-grep-args.nvim'

  -- for gitlinker
  Plug 'nvim-lua/plenary.nvim'
  -- \gy Copy github url
  Plug 'ruifm/gitlinker.nvim'
  -- TODO
  -- https://github.com/chrisgrieser/nvim-various-textobjs

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
