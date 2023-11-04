-- Dependencies:
-- - ripgrep (telescope live grep)
vim.cmd([[
set number
set relativenumber
set cursorline
set scrolloff=5
set showmode "Like, VISUAL or INSERT
set mouse=a "Can use mouse in [a]ll modes
set hlsearch "Highlight all search result
set incsearch "show search results as you type
set guicursor= "Set guicursor to block in nvim

set tabstop=2
set shiftwidth=2
set expandtab
set smartindent

let mapleader=" "
inoremap jk <ESC>

" Easy yank to system clipoard
nmap Y "+y
vmap Y "+y

autocmd BufRead,BufNewFile *.jsm set filetype=javascript

" Let Telescope find in the project dir instead of /
let g:rooter_patterns = ['.git', '.svn', '!node_modules']
nnoremap <expr> sp ':Telescope find_files cwd='.FindRootDirectory().'/<cr>'
nnoremap <expr> sp ':Telescope grep_string cwd='.FindRootDirectory().'/<cr>'

" Reload nvim config
nnoremap <silent> <Leader>rc :source $MYVIMRC<cr>
]])

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	"nvim-lualine/lualine.nvim",
	"preservim/nerdcommenter",
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.3",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	"airblade/vim-rooter",
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			"stevearc/dressing.nvim",
		},
	},
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	"dstein64/vim-startuptime",

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
		},
	},

	-- Lsp stuff
	{ "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "neovim/nvim-lspconfig" },
	{ "simrat39/rust-tools.nvim" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/nvim-cmp" },
	{ "L3MON4D3/LuaSnip" },
	{ "mhartington/formatter.nvim" },

	{
		-- See :help lualine.txt
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = "|",
			},
		},
	},

	{
		-- :help indent_blankline.txt
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = { char = "┇" },
		},
	},

	{
		-- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				local gs = require("gitsigns")
				-- See https://github.com/lewis6991/gitsigns.nvim#keymaps
				vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "Preview git hunk" })
				vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { buffer = bufnr, desc = "Reset git hunk" })

				-- don't override the built-in and fugitive keymaps
				vim.keymap.set({ "n", "v" }, "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
				vim.keymap.set({ "n", "v" }, "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
			end,
		},
	},

	-- "gcc" to comment lines and "gc" in visual mode
	{ "numToStr/Comment.nvim", opts = {} },
})

require("catppuccin").setup({
	transparent_background = true,
})
vim.cmd("colorscheme catppuccin")

-- https://github.com/nvim-neo-tree/neo-tree.nvim#quickstart
require("neo-tree").setup({
	popup_border_style = "rounded",
	use_popups_for_input = false,
	window = {
		width = 30,
		mappings = {
			["<C-j>"] = "toggle_node",
		},
	},
})

require("lualine").setup({})

local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<esc>"] = actions.close,
			},
		},
	},
})
vim.keymap.set("n", "<leader>f", builtin.git_files, {})
vim.keymap.set("n", "<leader>s", builtin.grep_string, {})
vim.keymap.set("n", "<leader>g", builtin.live_grep, {})
vim.keymap.set("n", "<leader>b", builtin.buffers, {})
-- vim.keymap.set("n", "<leader>h", builtin.help_tags, {})

require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all" (the five listed parsers should always be installed)
	ensure_installed = { "c", "lua", "vim", "rust", "javascript", "typescript", "bash", "html", "css" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,

	highlight = {
		enable = true,

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
})
vim.treesitter.language.register("bash", "zsh")

local lsp_zero = require("lsp-zero")
lsp_zero.on_attach(function(_, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({ buffer = bufnr })
end)

-- see :help lsp-zero-guide:integrate-with-mason-nvim
-- to learn how to use mason.nvim with lsp-zero
require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = { "rust_analyzer" },
	handlers = {
		lsp_zero.default_setup,
		lua_ls = function()
			local lua_opts = lsp_zero.nvim_lua_ls()
			require("lspconfig").lua_ls.setup(lua_opts)
		end,
	},
})
local lspconfig = require("lspconfig")
lspconfig.htmx.setup({
	filetypes = { "html", "htmldjango" },
})
lspconfig.html.setup({
	filetypes = { "html", "htmldjango" },
})

local rt = require("rust-tools")
rt.setup({
	server = {
		on_attach = function(_, bufnr)
			-- Hover actions
			vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
			-- Code action groups
			vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
		end,
	},
})

-- Autocomplete stuff
local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }

local kind_icons = {
	Text = "",
	Method = "󰆧",
	Function = "󰊕",
	Constructor = "",
	Field = "󰇽",
	Variable = "󰂡",
	Class = "󰠱",
	Interface = "",
	Module = "",
	Property = "󰜢",
	Unit = "",
	Value = "󰎠",
	Enum = "",
	Keyword = "󰌋",
	Snippet = "",
	Color = "󰏘",
	File = "󰈙",
	Reference = "",
	Folder = "󰉋",
	EnumMember = "",
	Constant = "󰏿",
	Struct = "",
	Event = "",
	Operator = "󰆕",
	TypeParameter = "󰅲",
}

cmp.setup({
	-- Preselect first item
	preselect = "item",
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
	sources = {
		{ name = "path" },
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "calc" },
	},
	formatting = {
		format = function(entry, vim_item)
			-- Kind icons
			vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
			-- Source
			vim_item.menu = ({
				buffer = "[Buffer]",
				nvim_lsp = "",
				luasnip = "[LuaSnip]",
				nvim_lua = "[Lua]",
				latex_symbols = "[LaTeX]",
			})[entry.source.name]
			return vim_item
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
		["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
		["<Tab>"] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete(),
	}),
})

vim.keymap.set("n", "<leader>rn", function()
	vim.lsp.buf.rename()
end)
vim.keymap.set("n", "<leader>w", "<Cmd>Neotree toggle<CR>")

-- Formatting
local prettierd = function()
	return {
		exe = "prettier",
		args = { vim.api.nvim_buf_get_name(0) },
		stdin = true,
	}
end

local util = require("formatter.util")
require("formatter").setup({
	logging = true,
	log_level = vim.log.levels.WARN,
	filetype = {

		htmldjango = { prettierd },
		html = { prettierd },
		lua = {
			-- "formatter.filetypes.lua" defines default configurations for the
			-- "lua" filetype
			require("formatter.filetypes.lua").stylua,

			-- You can also define your own configuration
			function()
				-- Supports conditional formatting
				if util.get_current_buffer_file_name() == "special.lua" then
					return nil
				end

				-- Full specification of configurations is down below and in Vim help
				-- files
				return {
					exe = "stylua",
					args = {
						"--search-parent-directories",
						"--stdin-filepath",
						util.escape_path(util.get_current_buffer_file_path()),
						"--",
						"-",
					},
					stdin = true,
				}
			end,
		},

		["*"] = {
			-- "formatter.filetypes.any" defines default configurations for any
			-- filetype
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})

-- Format on save
vim.cmd([[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost * FormatWrite
augroup END
]])
