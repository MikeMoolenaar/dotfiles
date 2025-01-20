-- System dependencies:
-- - ripgrep (telescope live grep)
-- - fzf (improve fuzzy search in telescope)
-- - stylua (via Cargo)
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
set linebreak "Wrap at word boundaries

set tabstop=2
set shiftwidth=2
set expandtab
set smartindent
set noswapfile

let mapleader=" "
inoremap jk <ESC>
nnoremap <C-c> <ESC>

" Some remaps to center current line in vertical center
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

" Use system clipboard
set clipboard=unnamedplus

" Let Telescope find in the project dir instead of /
let g:rooter_patterns = ['.git', '.svn', '!node_modules']
nnoremap <expr> sp ':Telescope find_files cwd='.FindRootDirectory().'/<cr>'
nnoremap <expr> sp ':Telescope grep_string cwd='.FindRootDirectory().'/<cr>'

" Reload neovim config
nnoremap <silent> <Leader>rc :source $MYVIMRC<cr>
]])

-- Set up automatic spell checking
-- `z=` to see suggestions, `zg` to add to dictionary
vim.opt.spelllang = "en"
vim.opt.spell = true

-- Setup LazyVim
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

require("lazy").setup({
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	"nvim-lualine/lualine.nvim",
	"preservim/nerdcommenter",
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.3",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- "nvim-telescope/telescope-fzf-native.nvim",
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
	"ThePrimeagen/harpoon",
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	"luckasRanarison/tree-sitter-hyprlang",
	"github/copilot.vim",
	{ "folke/todo-comments.nvim", opts = {} },

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
			delay = 400,
		},
	},

	-- Lsp stuff
	{ "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "neovim/nvim-lspconfig" },
	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		init = function()
			-- Configure rustaceanvim here
			vim.g.rustaceanvim = {
				server = {
					cmd = function()
						local ra_bin =
							vim.fn.expand("$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/rust-analyzer")
						return { ra_bin }
					end,
					on_attach = function(client, bufnr)
						-- you can also put keymaps in here
					end,
				},
			}
		end,
		lazy = false,
	},
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-cmdline" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-calc" },
	{ "hrsh7th/nvim-cmp" },
	{ "L3MON4D3/LuaSnip" },
	{ "mhartington/formatter.nvim" },
	{ "dawsers/edit-code-block.nvim" },

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
		"RRethy/vim-illuminate",
		event = "LspAttach",
		opts = {
			delay = 200,
		},
		config = function(_, opts)
			require("illuminate").configure(opts)
		end,
	},
	{
		-- :help indent_blankline.txt
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
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
				-- Custom keybindings
				vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "Preview git hunk" })
				vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { buffer = bufnr, desc = "Reset git hunk" })
				vim.keymap.set("n", "]g", gs.next_hunk, { buffer = bufnr, desc = "Next git hunk" })
				vim.keymap.set("n", "[g", gs.prev_hunk, { buffer = bufnr, desc = "Previous git hunk" })
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


-- Custom comment.nvim config
local ft = require("Comment.ft")
ft.systemd = "#%s"

-- Harpoon
require("harpoon").setup()
local harpoonmarker = require("harpoon.mark")
local harpoonui = require("harpoon.ui")
vim.keymap.set("n", "<leader>u", harpoonui.toggle_quick_menu, { desc = "Harpoon menu" })
vim.keymap.set("n", "<leader>a", harpoonmarker.add_file, { desc = "Harpoon add file" })

vim.keymap.set("n", "<leader>j", function()
	harpoonui.nav_file(1)
end, { desc = "Harpoon jump to file 1" })
vim.keymap.set("n", "<leader>k", function()
	harpoonui.nav_file(2)
end, { desc = "Harpoon jump to file 2" })
vim.keymap.set("n", "<leader>l", function()
	harpoonui.nav_file(3)
end, { desc = "Harpoon jump to file 3" })
vim.keymap.set("n", "<leader>;", function()
	harpoonui.nav_file(4)
end, { desc = "Harpoon jump to file 4" })
vim.keymap.set("n", "<leader>'", function()
	harpoonui.nav_file(5)
end, { desc = "Harpoon jump to file 5" })

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

-- Setup copilot
vim.cmd([[
  imap <silent><script><expr> <C-Space> copilot#Accept("\<CR>")
  let g:copilot_no_tab_map = v:true
]])

-- Open code block in buffer so LSP works.
-- TODO: currently, must call :LspRestart to get LSP to work again
-- Setup https://github.com/dawsers/edit-code-block.nvim
require("ecb").setup({
	wincmd = "split", -- this is the default way to open the code block window
})

local todo_comments = require("todo-comments")
todo_comments.setup()

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
-- require("telescope").load_extension("fzf")
vim.keymap.set("n", "<leader>f", builtin.git_files, { desc = "Telescope git files" })
vim.keymap.set("n", "<leader>v", builtin.find_files, { desc = "Telescope all files" })
vim.keymap.set("n", "<leader>s", builtin.grep_string, { desc = "Telescope string search" })
vim.keymap.set("n", "<leader>g", builtin.live_grep, { desc = "Telescope live search" })
vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "Telescope search current string" })
-- vim.keymap.set("n", "<leader>h", builtin.help_tags, {})

-- Treesitter for syntax highlighting + parsing syntax stuff (idk actually)
require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all"
	ensure_installed = { "c", "lua", "vim", "rust", "javascript", "typescript", "bash", "html", "css", "dockerfile" },

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
vim.filetype.add({
	pattern = { [".*/hyprland%.conf"] = "hyprlang" },
})

local lsp_zero = require("lsp-zero")
lsp_zero.preset("recommended")
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
		"html",
		"lua_ls",
		"tsserver",
		"htmx",
		-- "stylua", -- Must be installed via Cargo
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
lspconfig.tsserver.setup({
	filetypes = { "typescript", "javascript" },
})

-- Autocomplete stuff
local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }

-- Next/prev reference
local illuminate = require("illuminate")
local function map_illuminate(key, dir, buffer)
	vim.keymap.set("n", key, function()
		illuminate["goto_" .. dir .. "_reference"](false)
	end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
end

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

local lspkind_comparator = function(conf)
	local lsp_types = require("cmp.types").lsp
	return function(entry1, entry2)
		if entry1.source.name ~= "nvim_lsp" then
			if entry2.source.name == "nvim_lsp" then
				return false
			else
				return nil
			end
		end
		local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
		local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]
		if kind1 == "Variable" and entry1:get_completion_item().label:match("%w*=") then
			kind1 = "Parameter"
		end
		if kind2 == "Variable" and entry2:get_completion_item().label:match("%w*=") then
			kind2 = "Parameter"
		end

		local priority1 = conf.kind_priority[kind1] or 0
		local priority2 = conf.kind_priority[kind2] or 0
		if priority1 == priority2 then
			return nil
		end
		return priority2 < priority1
	end
end

local label_comparator = function(entry1, entry2)
	return entry1.completion_item.label < entry2.completion_item.label
end

cmp.setup({
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
	-- Preselect first item
	preselect = "item",
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "path" },
		{ name = "calc" },
	},
	sorting = {
    comparators = {
      lspkind_comparator({
        kind_priority = {
          Parameter = 14,
          Variable = 12,
          Field = 11,
          Property = 11,
          Constant = 10,
          Enum = 10,
          EnumMember = 10,
          Event = 10,
          Function = 10,
          Method = 10,
          Operator = 10,
          Reference = 10,
          Struct = 10,
          File = 8,
          Folder = 8,
          Class = 5,
          Color = 5,
          Module = 5,
          Keyword = 2,
          Constructor = 1,
          Interface = 1,
          Snippet = 0,
          Text = 1,
          TypeParameter = 1,
          Unit = 1,
          Value = 1,
        },
      }),
      label_comparator
    },
  },
  formatting = {
    format = function(entry, vim_item)
      -- This concatonates the icons with the name of the item kind
      vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
      vim_item.menu = ({
        buffer = "[Buffer]",
        calc = "[Calc]",
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
    ["<tab>"] = cmp.mapping.confirm({ select = true }),
    ["<C-e>"] = cmp.mapping.abort(),
  }),
})
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline({
    ["<tab>"] = { c = cmp.mapping.confirm({ select = true }) },
  }),
  sources = {
    { name = "buffer" },
  },
})
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline({
    ["<tab>"] = { c = cmp.mapping.confirm({ select = true }) },
  }),
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

local is_neotree_focused = function()
	-- Get our current buffer number
	local bufnr = vim.api.nvim_get_current_buf and vim.api.nvim_get_current_buf() or vim.fn.bufnr()
	-- Get all the available sources in neo-tree
	for _, source in ipairs(require("neo-tree").config.sources) do
		-- Get each sources state
		local state = require("neo-tree.sources.manager").get_state(source)
		-- Check if the source has a state, if the state has a buffer and if the buffer is our current buffer
		if state and state.bufnr and state.bufnr == bufnr then
			return true
		end
	end
	return false
end

local focus_toggle_neotree = function()
	if is_neotree_focused() then
		vim.cmd(":wincmd w")
	else
		vim.cmd(":Neotree reveal")
	end
end
vim.keymap.set("n", "<leader>w", function()
	focus_toggle_neotree()
end, { desc = "Neotree focus toggle" })
vim.keymap.set("n", "<leader>n", ":Neotree toggle<CR>", { desc = "Neotree toggle" })

require("formatter").setup({
	logging = true,
	log_level = vim.log.levels.WARN,
	filetype = {

		-- htmldjango = { prettierd },
		-- html = { prettierd },
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
		rust = {
			require("formatter.filetypes.rust").rustfmt,
		},

		["*"] = {
			-- "formatter.filetypes.any" defines default configurations for any
			-- filetype
			-- require("formatter.filetypes.any").remove_trailing_whitespace,
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

-- Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 200 })
	end,
})

-- Diagonstics
vim.diagnostic.config({
	virtual_text = {
		suffix = " ",
		source = "if_many",
	},
	severity_sort = true,
})

-- Custom keybindings for diagnostics
-- Source https://www.joshmedeski.com/posts/underrated-square-bracket/
--
-- -- Diagnostic general
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })

-- Diagnostic error
vim.keymap.set("n", "]e", function()
	vim.diagnostic.goto_next({ severity = "ERROR" })
end, { desc = "Next Error" })
vim.keymap.set("n", "[e", function()
	vim.diagnostic.goto_prev({ severity = "ERROR" })
end, { desc = "Prev Error" })

-- Diagnostic warning
vim.keymap.set("n", "]w", function()
	vim.diagnostic.goto_next({ severity = "WARN" })
end, { desc = "Next Warning" })
vim.keymap.set("n", "[w", function()
	vim.diagnostic.goto_prev({ severity = "WARN" })
end, { desc = "Prev Warning" })

-- TODO
vim.keymap.set("n", "]t", function()
	todo_comments.jump_next()
end, { desc = "Next TODO" })
vim.keymap.set("n", "[t", function()
	todo_comments.jump_prev()
end, { desc = "Previous TODO" })

-- Insert empty line
vim.keymap.set("n", "[<space>", ":pu! _<cr>:']+1<cr>", { desc = "Insert empty line above" })
vim.keymap.set("n", "]<space>", ":pu _<cr>:'[-1<cr>", { desc = "Insert empty line below" })

-- for htmx-lsp development
--[[
id = vim.lsp.start_client({
	cmd = { "/home/mike/git/htmx-lsp/target/debug/htmx-lsp", "--level", "INFO" },
	filetypes = { "html", "htmldjango" },
	root_dir = vim.loop.cwd(),
})
local function attach_lsp(args)
	if id == nil then
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	if not vim.lsp.buf_is_attached(bufnr, id) then
		vim.lsp.buf_attach_client(bufnr, id)
	end
end

vim.api.nvim_create_autocmd("BufEnter", {
	callback = attach_lsp,
})
--]]
