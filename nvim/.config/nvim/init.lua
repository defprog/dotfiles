--  Vim options
----------------------------------------------------------------
vim.keymap.set('n', '<Space>', '', {})
vim.g.mapleader = ' '
vim.keymap.set('n', '<Leader><Leader><Leader><Leader>', ':e ~/.config/nvim/init.lua<CR>', {})

vim.opt.number = true
vim.opt.cursorline = true

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.hlsearch = false
vim.opt.termguicolors = true
vim.opt.scrolloff = 7

vim.opt.fileformats = { 'unix' }
vim.opt.encoding = 'UTF-8'
vim.opt.relativenumber = true
vim.opt.swapfile = false

vim.opt.shell = 'nu'
vim.opt.shellcmdflag = '-c'
vim.opt.shellquote = '\"'
vim.opt.shellxquote = ''
--vim.o.laststatus = 2
--vim.o.cmdheight = 0

vim.api.nvim_create_autocmd('FileType', {
	pattern = 'json',
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
	end
})

----------------------------------------------------------------
-- 💤 Lazy config
----------------------------------------------------------------
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local out = vim.fn.system({
		'git', 'clone', '--filter=blob:none', '--branch=stable',
		'https://github.com/folke/lazy.nvim.git', lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
			{ out,                            'WarningMsg' },
			{ '\nPress any key to exit...' },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	{
		'kylechui/nvim-surround',
		event = 'VeryLazy',
		config = function()
			require('nvim-surround').setup()
			vim.keymap.set('x', '<leader>s', '<Plug>(nvim-surround-visual)')
			vim.keymap.set('n', '<leader>ds', '<Plug>(nvim-surround-delete)')
			vim.keymap.set('n', '<leader>cs', '<Plug>(nvim-surround-change)')
		end,
	},
	{ 'tpope/vim-repeat' },
	{ 'tpope/vim-fugitive' },
	{
		'neovim-treesitter/nvim-treesitter',
		dependencies = { 'nvim-lua/plenary.nvim' },
		lazy = false,
		build = ':TSUpdate',
		config = function()
			-- install is a no-op for already-installed parsers
			require('nvim-treesitter').install({
				'c', 'lua', 'vim', 'vimdoc', 'query', 'rust', 'python', 'cpp', 'go'
			})
		end,
	},
	{ 'chrismccord/bclose.vim' },
	{ 'nvim-tree/nvim-web-devicons' },
	{ 'milkypostman/vim-togglelist' },
	{ 'mortepau/codicons.nvim' },
	{ 'AckslD/nvim-neoclip.lua' },
	{ 'EdenEast/nightfox.nvim' },
	{ 'dasupradyumna/midnight.nvim', lazy = false, priority = 1000 },
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{ 'nvim-neotest/nvim-nio' },
	{ 'sQVe/sort.nvim' },
	{ 'catgoose/nvim-colorizer.lua' },

	-- LSP stuff
	{ 'neovim/nvim-lspconfig' },
	{ 'hrsh7th/nvim-cmp' },
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/cmp-buffer' },
	{ 'hrsh7th/cmp-path' },
	{ 'hrsh7th/cmp-cmdline' },
	{ 'williamboman/mason.nvim' },
	{ 'williamboman/mason-lspconfig.nvim' },
	{ 'jay-babu/mason-nvim-dap.nvim' },
	{ 'L3MON4D3/LuaSnip' },
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	-- end LSP stuff

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {
			modes = {
				char = {
					enabled = false,
				},
			}
		},
		-- stylua: ignore
		keys = {
			{ "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
			{ "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
			{ "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
			{ "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
		},
	},
	{
		"hedyhli/outline.nvim",
		config = function()
			vim.keymap.set("n", "<leader>a", "<cmd>Outline<CR>",
				{ desc = "Toggle Outline" })
			require("outline").setup {
			}
		end,
	},
	{
		'dgagn/diagflow.nvim',
		event = 'LspAttach',
		opts = {},
	},
	{ 'smartpde/telescope-recent-files' },
	{ 'nvim-telescope/telescope-symbols.nvim' },
	{
		'nvim-telescope/telescope.nvim',
		version = '*',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make',
			},
		},
	},

	{
		'folke/trouble.nvim',
		config = function()
			local trouble = require("trouble.sources.telescope")
			local telescope = require("telescope")
			telescope.setup {
				opts = {},
				icons = true,
				defaults = {
					mappings = {
						i = { ["<c-t>"] = trouble.open },
						n = { ["<c-t>"] = trouble.open },
					},
				},
			}
		end
	},

	{
		'stevearc/oil.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
	},

	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
	},


	{
		'mfussenegger/nvim-dap',
		ft = { 'rust' },
		cmd = { 'DapContinue', 'DapBreakpoint' }
	},
	{
		'rcarriga/nvim-dap-ui',
		dependencies = { 'mfussenegger/nvim-dap' }
	},
	{
		'https://git.sr.ht/~swaits/scratch.nvim',
		lazy = true,
		keys = {
			{ '<leader>bs', '<cmd>Scratch<cr>',      desc = 'Scratch Buffer',         mode = 'n' },
			{ '<leader>bS', '<cmd>ScratchSplit<cr>', desc = 'Scratch Buffer (split)', mode = 'n' },
		},
		cmd = {
			'Scratch',
			'ScratchSplit',
		},
		opts = {},
	},
	{
		'NeogitOrg/neogit',
		dependencies = {
			'nvim-lua/plenary.nvim', -- required
			'sindrets/diffview.nvim', -- optional - Diff integration
			'nvim-telescope/telescope.nvim', -- optional
		},
		config = true
	}
})

----------------------------------------------------------------
-- 🎨 Theme
----------------------------------------------------------------
--require('nightfox').setup({})

vim.opt.background = "dark"
-- colorscheme tokyonight-night
vim.cmd [[
colorscheme tokyonight-night
]]
--vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })

-- local palette = require('nightfox.palette').load('duskfox')
-- local yellow = palette.yellow.bright
local palette = require("tokyonight.colors").setup({ style = "night" })
local yellow = palette.yellow
-- local yellow = '#edfc20'

vim.cmd("hi clear FlashLabel")
vim.api.nvim_set_hl(0, "FlashLabel",
	{ fg = yellow, bg = "#000000", bold = true, default = false })

require('lualine').setup {
	extensions = {
		'trouble', 'quickfix', 'oil', 'nvim-dap-ui', 'mason', 'lazy', 'fugitive'
	},
	sections = {
		lualine_z = { 'encoding', 'fileformat', 'filetype' },
		lualine_y = { 'location' },
		lualine_x = { {
			'buffers',
			mode = 0,
		} },
		lualine_b = { { 'filename', path = 1 } },
		lualine_c = {},
	},
}

require('colorizer').setup()

----------------------------------------------------------------
-- small requires
----------------------------------------------------------------

require('oil').setup({
	columns = {
		"icon",
		"permissions",
		"size",
		"mtime",
	},
})
vim.keymap.set('n', '<leader><CR>', function()
	local oil = require('oil')
	local entry = oil.get_cursor_entry()
	if not entry then return end

	local path = oil.get_current_dir() .. '/' .. entry.name
	if entry.type ~= 'directory' then
		local opener = 'xdg-open'
		vim.fn.jobstart({ opener, path }, { detach = true })
	else
		oil.select()
	end
end, { desc = 'Open file externally', buffer = true })


vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

--vim.cmd(':Copilot disable')

require('trouble').setup()

----------------------------------------------------------------
-- 🌳 treesitter config
----------------------------------------------------------------

-- enable highlighting for any filetype that has a parser installed
vim.api.nvim_create_autocmd('FileType', {
	pattern = '*',
	callback = function() pcall(vim.treesitter.start) end,
})

vim.keymap.set('n', '[p', ':lua JumpToXMLParent()<CR>', { noremap = true, silent = true })

function JumpToXMLParent()
	local node = vim.treesitter.get_node()
	if not node then return end

	local parent = node:parent()
	while parent do
		if parent:type() == 'element' then
			parent = parent:parent()
			local start_row, start_col, _, _ = parent:range()
			vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
			return
		end
		parent = parent:parent()
	end
end

----------------------------------------------------------------
-- 🔭 telescope config and keybindings
----------------------------------------------------------------
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local telescope = require('telescope')
telescope.setup {
	defaults = {
		mappings = {
			n = {
				['<C-x>'] = actions.delete_buffer,
				['<C-n>'] = actions.cycle_history_next,
				['<C-p>'] = actions.cycle_history_prev,
				['<C-a>'] = actions.select_all,
			},
			i = {
				['<C-j>'] = actions.move_selection_next,
				['<C-k>'] = actions.move_selection_previous,
				['<C-n>'] = actions.cycle_history_next,
				['<C-p>'] = actions.cycle_history_prev,
			},
		},
		extensions = {
			fzf = {
				fuzzy = true,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = "smart_case",
			},
		},
	},
	pickers = {
		buffers = {
			theme = 'ivy'
		}
	}
};


vim.keymap.set('n', '<leader>bb', builtin.builtin, {})
vim.keymap.set('n', '<leader>fF', function()
	builtin.find_files({ hidden = true })
end, {})
vim.keymap.set('n', '<leader>fd', function()
	builtin.diagnostics({ sort_by = 'severity' })
end, {})
vim.keymap.set('n', '<leader>ff', builtin.git_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', function()
	builtin.buffers({
		sort_lastused = true,
		ignore_current_buffer = true,
		initial_mode = 'normal',
	})
end, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>f.', builtin.current_buffer_fuzzy_find, {})
vim.keymap.set('n', '<leader>fl', ':Telescope resume<CR>', {})
vim.keymap.set('n', '<leader>fc', ':Telescope neoclip theme=ivy<CR>', {})
vim.keymap.set('n', '<leader>fm', ':Telescope marks theme=ivy<CR>', {})
vim.keymap.set('n', '<leader>fs', ':Telescope symbols<CR>', {})
vim.keymap.set('n', '<leader>fk', ':Telescope keymaps<CR>', {})
vim.keymap.set('n', '<Leader>fr', function()
	require('telescope').extensions.recent_files.pick()
end, { silent = true })

telescope.load_extension('fzf')
telescope.load_extension('recent_files')
require('neoclip').setup({
	keys = {
		telescope = {
			i = {
				paste_behind = {}
			}
		},
	},
})

----------------------------------------------------------------
-- jump buffers
----------------------------------------------------------------
local buffer_map = {}
vim.keymap.set('n', '<leader>m', function()
	local key = vim.fn.nr2char(vim.fn.getchar())
	buffer_map[key] = vim.fn.bufnr("%")
end)

vim.keymap.set('n', '<leader>j', function()
	local key = vim.fn.nr2char(vim.fn.getchar())
	if buffer_map[key] then
		vim.cmd('buffer ' .. buffer_map[key])
	end
end)

----------------------------------------------------------------
-- 🦀 rust debug config and keybindings
----------------------------------------------------------------
function _G.cargo_build()
	vim.cmd('split | terminal cargo build')
end

function _G.cargo_build_release()
	vim.cmd('split | terminal cargo build --release')
end

function _G.cargo_run_release()
	vim.cmd('split | terminal cargo run')
	vim.cmd(':startinsert')
end

function _G.cargo_test()
	vim.cmd('split | terminal cargo test -- --nocapture')
	vim.cmd(':startinsert')
end

function _G.cargo_clippy_pedantic()
	vim.cmd('split | terminal cargo clippy --all -- -W clippy::pedantic')
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "rust",
	callback = function()
		vim.keymap.set('n', '<F6>', cargo_build, { buffer = true, silent = true })
		vim.keymap.set('n', '<Leader><F6>', cargo_build_release, { buffer = true, silent = true })
		vim.keymap.set('n', '<Leader>r', cargo_run_release, { buffer = true, silent = true })
		vim.keymap.set('n', '<Leader><Leader>t', cargo_test, { buffer = true, silent = true })
		vim.keymap.set('n', '<Leader><Leader>c', cargo_clippy_pedantic, { buffer = true, silent = true })
	end,
})

-- close term when process exits
-- vim.api.nvim_create_autocmd("TermClose", {
-- 	pattern = "*",
-- 	callback = function(opts)
-- 		-- close the buffer when the job ends
-- 		vim.api.nvim_buf_delete(opts.buf, { force = true })
-- 	end,
-- })

----------------------------------------------------------------
-- 🔌 LSP config (native 0.11+)
----------------------------------------------------------------

-- Default capabilities for all servers (nvim-cmp integration)
vim.lsp.config('*', {
	capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

-- Server-specific config
vim.lsp.config('rust_analyzer', {
	settings = {
		['rust-analyzer'] = {
			checkOnSave = true,
			check = { command = 'clippy' },
			cargo = {
				allFeatures = true,
				buildScripts = { enable = true },
			},
			procMacro = { enable = true },
		},
	},
})

require('mason').setup()
require('mason-lspconfig').setup({
	ensure_installed = { 'lua_ls', 'rust_analyzer', 'pylsp', 'jsonls', 'clangd' },
	automatic_enable = false,
})

vim.lsp.enable({ 'lua_ls', 'rust_analyzer', 'pylsp', 'jsonls', 'clangd' })

-- Keymaps and format-on-save on attach
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then return end

		-- grn, gra, grr, gri, grd, K, [d/]d are built-in defaults in 0.11+
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Go to definition' })
		vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, { buffer = bufnr, desc = 'Go to type definition' })
		vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature help' })
		vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'Code action' })
		vim.keymap.set('v', '<F4>', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'Code action' })

		-- Format on save for specific servers
		local format_servers = { rust_analyzer = true, lua_ls = true }
		if format_servers[client.name] then
			vim.api.nvim_create_autocmd('BufWritePre', {
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						bufnr = bufnr,
						async = false,
						timeout_ms = 10000,
						filter = function(c) return c.name == client.name end,
					})
				end,
			})
		end
	end,
})


----------------------------------------------------------------
-- 󱐀 nvim-cmp bindings
----------------------------------------------------------------
local cmp = require('cmp')
cmp.setup({
	completion = {
		autocomplete = false
	},
	mapping = cmp.mapping.preset.insert({
		['<C-s>'] = cmp.mapping.complete(),
		['<C-k>'] = cmp.mapping.select_prev_item(),
		['<C-j>'] = cmp.mapping.select_next_item(),
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),
		['<C-e>'] = cmp.mapping.close(),
		['<CR>'] = cmp.mapping.confirm({ select = false }),
	}),
	sources = cmp.config.sources({
		{ name = 'lazydev', group_index = 0 },
		{
			name = 'nvim_lsp',
			entry_filter = function(entry, _)
				return vim.lsp.protocol.CompletionItemKind.Snippet ~= entry:get_kind()
			end
		},
	}),
})

----------------------------------------------------------------
--   DAP config
----------------------------------------------------------------
local dap = require('dap')
local dapui = require('dapui')
dapui.setup()
dap.listeners.after.event_initialized['dapui_config'] = function()
	dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
	dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
	dapui.close()
end

require('mason-nvim-dap').setup({
	ensure_installed = { 'codelldb' },
	handlers = {},
})

vim.keymap.set('n', '<F5>', ':DapContinue<CR>')
vim.keymap.set('n', '<F10>', ':DapStepOver<CR>')
vim.keymap.set('n', '<Leader><F10>', ':DapStepInto<CR>')
vim.keymap.set('n', '<F12>', ':DapStepOut<CR>')
vim.keymap.set('n', '<F9>', ':DapToggleBreakpoint<CR>')
vim.keymap.set('n', '<Leader>x', ':DapTerminate<CR>:lua require("dapui").close()<CR>')

vim.fn.sign_define('DapBreakpoint', { text = '⭕', texthl = '', })
vim.fn.sign_define('DapStopped', { text = '🔴', texthl = '', })

----------------------------------------------------------------
-- After
----------------------------------------------------------------
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead', 'FileType' }, {
	pattern = '*',
	callback = function() vim.opt_local.formatoptions:remove({ 'r', 'o' }) end,
})

----------------------------------------------------------------
--   other keybindings
----------------------------------------------------------------
vim.keymap.set('n', '<C-n>', ':cnext<CR>', {})
vim.keymap.set('n', '<C-p>', ':cprev<CR>', {})
vim.keymap.set('n', '<Leader>bd', ':bd<CR>', {})
vim.keymap.set('n', '<Leader>bD', ':bd!<CR>', {})
vim.keymap.set('n', '<Leader>bc', ':Bclose<CR>', {})
vim.keymap.set('n', '<Leader>bC', ':Bclose!<CR>', {})

vim.keymap.set('n', '<Leader>y', '"+y')
vim.keymap.set('v', '<Leader>y', '"+y')
vim.keymap.set('n', '<Leader>p', '"+p')
vim.keymap.set('v', '<Leader>p', '"+p')
vim.keymap.set('n', '<Leader>P', '"+P')
vim.keymap.set('v', '<Leader>P', '"+P')

vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('n', '<Leader>t', ':Trouble diagnostics toggle focus=true<CR>')
vim.keymap.set('n', '<Leader>w', '<C-w>')
vim.keymap.set({ 'n', 'i' }, '<F1>', '<Escape>')
vim.keymap.set('t', '<ESC>', '<C-\\><C-n>', { noremap = true })

vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")

vim.keymap.set('n', '<Leader>ql', ':call ToggleLocationList()<CR>')
vim.keymap.set('n', '<Leader>qf', ':call ToggleQuickfixList()<CR>')
vim.keymap.set('n', '<Leader>qc', ':cex []<CR>')
vim.keymap.set('n', '<Right>', ':vertical resize +5<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Left>', ':vertical resize -5<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Up>', ':horizontal resize -5<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Down>', ':horizontal resize +5<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<Leader><Leader>s', ':vsplit | term<CR>')
vim.keymap.set('n', '<Leader><Leader>b', ':b#<CR>')

vim.keymap.set('n', '[T', 'tavatov', { noremap = true, silent = true })
