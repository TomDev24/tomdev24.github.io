let g:user42 = 'dbrittan'
let g:mail42 = 'dbrittan@student.42.fr'
let $snippets = '~/.vim/snippets'

set nocompatible
set nu
syntax enable
filetype plugin on

" fuzzy file loading
set path+=**
set wildmenu

"AutoCmd
let g:netrw_keepdir=0
autocmd BufEnter * silent! lcd %:p:h
autocmd VimEnter * silent! let g:djpath = expand('%:p')

command! MakeTags !ctags -R .
command! Snps tabe $snippets

command! Settings tabe urls.py $djpath . "./" . "/settings.py"
command! Url tabe urls.py
command! View tabe views.py
command! Model tabe models.py
command! Temp tabe templates
command! Form tabe forms.py

set laststatus=2

" Snippets
nnoremap /doctype :-1read $snippets/html/doctype.html<CR>
nnoremap /db :-1read $snippets/django/db_set.py<CR>
nnoremap /makes :-1read $snippets/make/makes<CR>
nnoremap /main :-1read $snippets/cpp/main.cpp<CR>
nnoremap /clsh :-1read $snippets/cpp/classh.cpp<CR>:/CLASS<CR>ggncgn
nnoremap /clsr :-1read $snippets/cpp/classr.cpp<CR>:/Class<CR>cgn

let g:clang_library_path='/usr/lib/llvm-10/lib/libclang-10.so.1'
"ln -s libclang.so.1 libclang.so
call plug#begin()
"Plug 'davidhalter/jedi-vim'
Plug 'xavierd/clang_complete'
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/taglist.vim'
Plug 'mattn/emmet-vim'
" Plug 'shmup/vim-sql-syntax'
call plug#end()

