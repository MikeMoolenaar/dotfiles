-- System dependencies:
-- - ripgrep (telescope live grep)
-- - fzf (improve fuzzy search in telescope)
vim.cmd([[
set number
set relativenumber
set cursorline
set scrolloff=5
set showmode "Like, VISUAL or INSERT
set mouse=a "Can use mouse in [a]ll modes
set hlsearch "Highlight all search result
set incsearch "show search results as you type
set guicursor= "Set guicursor to block in neovim
set ignorecase "Ignore case when searching
set smartcase "Unless we explicitly use cases in search

set tabstop=2
set shiftwidth=2
set expandtab
set smartindent

let mapleader=" "
inoremap jk <ESC>

" Easy yank to system clipboard
nmap Y "+y
vmap Y "+y

autocmd BufRead,BufNewFile *.jsm set filetype=javascript

" Let Telescope find in the project dir instead of /
let g:rooter_patterns = ['.git', '.svn', '!node_modules']
nnoremap <expr> sp ':Telescope find_files cwd='.FindRootDirectory().'/<cr>'
nnoremap <expr> sp ':Telescope grep_string cwd='.FindRootDirectory().'/<cr>'

" Reload neovim config
nnoremap <silent> <Leader>rc :source $MYVIMRC<cr>
]])

-- z= to see suggestions, zg to add to dictionary
-- Set up automatic spell checking
vim.opt.spelllang = "en"
vim.opt.spell = true

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
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
		},
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

	-- :StartupTime
	"dstein64/vim-startuptime",

	-- switch (like, true/false) with key `gs`
	-- also works in markdown checklists
	-- https://github.com/AndrewRadev/switch.vim
	"AndrewRadev/switch.vim",

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500
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
	{ "hrsh7th/cmp-cmdline" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/nvim-cmp" },
	{ "L3MON4D3/LuaSnip" },
	{ "mhartington/formatter.nvim" },

	-- LSP progress
	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = "LspAttach",
		opts = {
			-- options
		},
	},

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

-- Mmmmmm theme
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

-- Status line
require("lualine").setup({})

-- Telescope for finding files and searching for strings, and more...
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
require("telescope").load_extension("fzf")
vim.keymap.set("n", "<leader>f", builtin.git_files, { desc = "Telescope git files" })
vim.keymap.set("n", "<leader>v", builtin.find_files, { desc = "Telescope all files" })
vim.keymap.set("n", "<leader>s", builtin.grep_string, { desc = "Telescope string search" })
vim.keymap.set("n", "<leader>g", builtin.live_grep, { desc = "Telescope live search" })
vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "Telescope search current string" })
-- vim.keymap.set("n", "<leader>h", builtin.help_tags, {})

-- Treesitter for syntax highlighting + parsing syntax stuff (idk actually)
require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all"
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
	ensure_installed = {
		"cssls",
		"html",
		"lua_ls",
		"rust_analyzer",
		-- "stylua",
		-- "gopls",
		-- "htmx",
	},
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
	tools = {
		inlay_hints = { auto = false },
	},
	server = {
		on_attach = function(_, bufnr)
			-- Code action groups
			vim.keymap.set(
				"n",
				"<Leader>a",
				rt.code_action_group.code_action_group,
				{ buffer = bufnr, desc = "Rust actions" }
			)
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
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{
			name = "cmdline",
			option = {
				ignore_cmds = { "Man", "!" },
			},
		},
	}),
})

vim.keymap.set("n", "<leader>rn", function()
	vim.lsp.buf.rename()
end, { desc = "Rename with LSP" })
vim.keymap.set("n", "<leader>w", "<Cmd>Neotree toggle<CR>")

-- Formatting
local prettierd = function()
	return {
		exe = "prettier",
		args = { vim.api.nvim_buf_get_name(0) },
		stdin = true,
	}
end

require("formatter").setup({
	logging = true,
	log_level = vim.log.levels.WARN,
	filetype = {

		htmldjango = { prettierd },
		html = { prettierd },
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
		rust = {
			require("formatter.filetypes.rust").rustfmt,
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

vim.diagnostic.config({
	virtual_text = {
		format = function(diagnostic)
			local lines = vim.split(diagnostic.message, "\n")
			return lines[1]
		end,
		virt_text_pos = "right_align", -- Not supported yet...
		suffix = " ",
	},
})
