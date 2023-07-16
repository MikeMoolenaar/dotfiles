set number
set relativenumber
set cursorline
set scrolloff=5
set showmode "Like, VISUAL or INSERT"
set mouse=a "Can use mouse in [a]ll modes"
set fillchars=vert:\│ "Change seperator line to continous non-dashed line"
set hlsearch "Highlight all search result"
set incsearch "show search results as you type"

call plug#begin()

Plug 'joshdick/onedark.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'
Plug 'davidhalter/jedi-vim'
Plug 'preservim/nerdtree'
Plug 'sheerun/vim-polyglot'

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
let NERDTreeShowHidden=1 "Toggle with {shift + i}"

call plug#end()

syntax on
colorscheme onedark
"Enable transparant background"
hi Normal guibg=NONE ctermbg=NONE
hi CursorLine ctermbg=NONE

