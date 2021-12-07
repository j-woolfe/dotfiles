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


" tpope goodness
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'

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

" Install LSP Servers
Plug 'williamboman/nvim-lsp-installer'

" Autocomplete
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}

" Snippets
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}

" Colour diagnostic messages
Plug 'folke/lsp-colors.nvim'

" Diagnostic icons and popup
Plug 'folke/trouble.nvim'

" Syntax highlighting
Plug 'sheerun/vim-polyglot'

" Split navigation
Plug 'numToStr/Navigator.nvim'

" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Improved Markdown support
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Rainbow Brackets
Plug 'luochen1990/rainbow'
" For treesitter languages
Plug 'p00f/nvim-ts-rainbow'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set colors to molokai transparent from https://github.com/Znuff/molokai
try
    " set t_Co=256
    colorscheme molokaiTransparent
    "colorscheme tokyonight
catch
endtry

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
let g:coq_settings.keymap = { 'jump_to_mark': '<c-s>' }

lua << EOF
-- LSP Config
local nvim_lsp = require "lspconfig"
local coq = require "coq"
local lsp_installer = require "nvim-lsp-installer"

-- Diagnostics (0.6+)
-- vim.diagnostic.config({
--    virtual_text = false
-- })

vim.o.updatetime = 250
-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
--}


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
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    -- <leader>e goto next [e]rror (E for prev)
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts) 
    buf_set_keymap('n', '<leader>E', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    -- <leader>ca perform [c]ode [a]ction
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    -- <leader>f [f]ormat buffer
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)


end

lsp_installer.on_server_ready( function (server)
    local opts = {
        on_attach = on_attach,
        flags = {
            debounce_text_changes = 150
        }
    }

    server:setup(coq.lsp_ensure_capabilities(opts))
end)

EOF

" lsp-colors defaults
lua << EOF
-- require("lsp-colors").setup({
    --Error = "#f4005f",
--    Error = "#ffffff",
--   Warning = "#fa8419",
--    Information = "#9f65ff",
--    Hint = "#98e024"
--})
EOF

" Use default trouble.nvim settings
lua << EOF
--require("trouble").setup({
--    signs = {
--        -- icons / text used for a diagnostic
--        error = "",
--        warning = "",
--        hint = "",
--        information = "",
--        other = "﫠"
--    },
--    use_lsp_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
--})
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

" Markdown Preview
" Open in chrome
let g:mkdp_browser = 'google-chrome-stable'

" Highlight Latex in markdown
let g:vim_markdown_math = 1

" Treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",
    highlight = {
        enable = true,
        disable = {"haskell"},
        additional_vim_regex_highlighting = false,
        },
    -- Rainbow parens
    rainbow = {
        enable = true,
        extended_mode = true,
        termcolors = {
            "8",
            "4",
            "2",
            "3",
            "6",
            "1",
            "2",
            }
        },
    }
EOF

" Rainbow parens
" Enable and set colours
let g:rainbow_active = 1
let g:rainbow_conf = {'ctermfgs': [4, 2, 3, 6, 1]}

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

" Use 4 spaces instead of tabs
set expandtab
set shiftwidth=4
set tabstop=4

" Use 2 spaces in Haskell
autocmd FileType haskell setlocal tabstop=2 shiftwidth=2 softtabstop=2

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

" Exit terminal mode normally
tnoremap <Esc> <C-\><C-n>

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
" Loclist for errors? trouble?
" Fix signs
"
" TODO MAYBE
" Quickfix bindings/toggle (in .vimrc)
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
"
" " Conceal Markdown emphasis
" autocmd BufRead,BufNewFile *.md
"     \ set conceallevel=2
"
"
"" Use vim config
" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath
" source ~/.vimrc
