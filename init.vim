"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim-Plug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Install vim-plug if not already installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Rainbow Brackets
Plug 'luochen1990/rainbow'

" tpope goodness
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

" Airline statusline and themes
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Sneak style motions
Plug 'ggandor/lightspeed.nvim'

" FZF integration
Plug 'ibhagwan/fzf-lua'
Plug 'vijaymarupudi/nvim-fzf'
Plug 'kyazdani42/nvim-web-devicons'

" LSP
Plug 'neovim/nvim-lspconfig'

" Autocomplete
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
" Snippets
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}

" Syntax highlighting
Plug 'sheerun/vim-polyglot'

" Split navigation
Plug 'numToStr/Navigator.nvim'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Rainbow parens
" Enable and set colours
let g:rainbow_active = 1
let g:rainbow_conf = {'ctermfgs': [4, 2, 3, 6, 1]}

" Airline
" Theme and font
let g:airline_powerline_fonts = 1
let g:airline_theme = 'modified_murmur'

" Buffers and tabs
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#buffer_min_count = 2

" FZF
lua << EOF
require('fzf-lua').setup{
    ["default-previewer"] = "bat",
    files = {
        cmd = "fd",
    },
    grep = {
        cmd = "rg --vimgrep",
    },
}
EOF

" <c-P> is fuzzy open file
nnoremap <c-P> <cmd>lua require('fzf-lua').files()<CR>
" <c-F> is fuzzy find in open files
nnoremap <c-F> <cmd>lua require('fzf-lua').grep_curbuf()<CR>


" COQ and LSP
" Autostart COQ
let g:coq_settings = { 'auto_start': 'shut-up' }

lua << EOF
-- LSP Config
local nvim_lsp = require "lspconfig"
local coq = require "coq"

-- Based on https://github.com/neovim/nvim-lspconfig example config
-- Defines a number of generic LSP keybinds
-- call on_attach in the setup to each LSP
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    -- local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    
    -- Mappings
    local opts = { noremap=true, silent=true }

    -- <leader>rn [r]e[n]ame
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<leader>k', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    -- [g]o [d]efinition (Use <C-o> to get back)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    -- [g]o [D]eclaration
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    -- <leader>e goto next [e]rror (E for prev)
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts) 
    buf_set_keymap('n', '<leader>E', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    -- <leader>ca perform [c]ode [a]ction
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    -- <leader>f [f]ormat buffer
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)


end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- NOTE: Using coq.lsp_ensure_capabilities for autocomplete compatibility
local servers = { 
    'vimls',                                -- vim
    'hls',                                  -- Haskell
    'tsserver',                             -- js/ts
    'rust_analyzer',                        -- Rust
    'pyright',                              -- Python
}

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup( coq.lsp_ensure_capabilities({
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }))
end
EOF

" Navigator.nvim
lua << EOF
require('Navigator').setup({
  auto_save = 'current',
  disable_on_zoom = true
})

-- Keybindings
-- Might be better to move to <A-h> and save <C-h> for other functions
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map('n', "<C-h>", "<CMD>lua require('Navigator').left()<cr>", opts)
map('n', "<C-j>", "<CMD>lua require('Navigator').down()<cr>", opts)
map('n', "<C-k>", "<CMD>lua require('Navigator').up()<cr>", opts)
map('n', "<C-l>", "<CMD>lua require('Navigator').right()<cr>", opts)
EOF

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable filetype plugins
filetype plugin on
filetype indent on

" Set leader to space
map <Space> <leader>

" Fast saving with <leader> w
nmap <leader>w :w!<cr>

" Rebind Wq to wq
command! Wq wq

" Rebind Q to q
command! Q q

" :W for sudo save
command W w !sudo tee % > /dev/null

" Enable mouse support
set mouse=a

" Sensible folding
set foldmethod=indent
set foldlevel=99
nnoremap <leader>z za

" Enable persistent undo
" May cause double writes to undo dir? Docs a little unclear
set undofile

" Set textwidth to 88 chars
set textwidth=88

" Keep 7 lines on screen
set scrolloff=7

" Enable line numbers
set number

" Show cursor line
set cursorline

" Ignore case when searching
set ignorecase
set smartcase

" Improve performance with lazy redraw
set lazyredraw

" Highlight matching brackets and blink for 2 tenths of a second
set showmatch
set mat=2

" Set colors to molokai transparent from https://github.com/Znuff/molokai
try
  colorscheme molokaiTransparent
catch
endtry

" Use 4 spaces instead of tabs
set expandtab
set shiftwidth=4
set tabstop=4

" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Keymaps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Toggle ColorColumn at 88 chars
" Bound to <leader>cl (Colour Line?)
nnoremap <silent> <leader>cl :execute "set colorcolumn=" . (&colorcolumn == "" ? "88" : "")<CR>

" Hide search highlighting with <leader><cr>
" Maybe move to a less important keybind? Maybe <leader>/ ?
map <silent> <leader><cr> :noh<cr>

" Split mappings
map <leader>\ :vsplit<cr>
map <leader>- :split<cr>

" Buffer mappings
" Navigate buffers
map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>
" [B]uffer Close [A]ll
map <leader>ba :bufdo bd<cr>
" [B]uffer [D]elete
map <leader>bd :Bclose<cr>

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")

  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif

  if bufnr("%") == l:currentBufNum
    new
  endif

  if buflisted(l:currentBufNum)
    execute("bdelete! ".l:currentBufNum)
  endif
endfunction

" Remap VIM 0 to first non-blank character
map 0 ^

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Might be needed
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Refreshes some plugins, default is 4000ms
" set updatetime=300
"
" Improves performance in files with long lines
" if &synmaxcol == 3000
"   set synmaxcol=500
" endif
"
" Hides buffer when abandoned
" set hidden
"

" TODO
" Figure out text wrapping for comments
" Bracket autopair? might not be worth the conflict with autocomplete
" More FZF bindings (project grep?)
" Async actions/tasks - formatting
" Vimspector debugger
" Check/setup clippy with rust_analyzer
" clangd language server (need to setup makefiles or something)
"
" TODO MAYBE
" Quickfix bindings/toggle (in .vimrc)
" Loclist for errors?
" Delete trailing whitespace on save
" Setup Lua LSP (sumneko_lua)
"
" Code for enabling web language servers
"
"    'html',                                 -- html
"    'cssls',                                -- css
"    'jsonls',                               -- json
"-- To enable completions for extracted VScode LS (HTML/CSS/JSON)
"--Enable (broadcasting) snippet capability for completion
"local capabilities = vim.lsp.protocol.make_client_capabilities()
"capabilities.textDocument.completion.completionItem.snippetSupport = true
"
"require'lspconfig'.jsonls.setup( coq.lsp_ensure_capabilities( {
"  capabilities = capabilities,
"  }))
"end

"" Use vim config
" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath
" source ~/.vimrc
