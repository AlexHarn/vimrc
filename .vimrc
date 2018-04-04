" Vundle
set nocompatible
filetype off
set rtp+=/home/alex/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
" plugins starting here

" install AUR packaged vim-latexsuite
Plugin 'Valloric/YouCompleteMe'
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'
" flake8 needs to be in path for syntastic to work!!!
Plugin 'vim-syntastic/syntastic'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'jiangmiao/auto-pairs'
Plugin 'wesQ3/vim-windowswap'
Plugin 'vim-scripts/Tabmerge'
Plugin 'tpope/vim-surround'
" nerdtree-execute is out of date, needs manual fixing: xdg-open, still not merged...
"Plugin 'ivalkeen/nerdtree-execute'
Plugin 'AlexHarn/nerdtree-execute'
Plugin 'vim-scripts/swap'
Plugin 'sudar/vim-arduino-syntax'
Plugin 'rdnetto/YCM-Generator.git'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'jacob-ogre/vim-syncr'

call vundle#end()

" general stuff
filetype plugin indent on
set encoding=utf-8
syntax on
set nu
set t_Co=256
set breakindent
set autoindent
set backspace=indent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
" safe makrs, registers, command history
set viminfo='10,\"100,:20,%,n~/.viminfo'

" autoupload on write with vim-syncr
autocmd BufWritePost * :Suplfil

" YouCompleteMe
let g:ycm_server_python_interpreter = '/usr/bin/python'
let g:ycm_python_binary_path = '/usr/bin/python'
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_global_ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
"let g:ycm_autoclose_preview_window_after_completion = 1
"let g:ycm_autoclose_preview_window_after_insertion = 1

" Powerline
set laststatus=2

" NerdTree
let NERDTreeShowLineNumbers=1
let g:nerdtree_tabs_open_on_console_startup=1
let g:nerdtree_tabs_open_on_gui_startup=0
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
function! ToggleNerdTreeSync()
    if g:nerdtree_tabs_synchronize_view
        let g:nerdtree_tabs_synchronize_view=0
	echo "Sync off"
    else
        let g:nerdtree_tabs_synchronize_view=1
	echo "Sync on"
    endif
endfunction

" NerdCommenter
let g:NERDCustomDelimiters = { 'arduino': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' } }

" vim-Latex (see also: Latex settings for keybinds)
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
let g:Tex_BibtexFlavor = 'biber'
let g:Tex_DefaultTargetFormat = "pdf"
let Tex_FoldedSections = ""
let Tex_FoldedEnvironments = ""
let Tex_FoldedMisc = ""
let g:Tex_ShowErrorContext = 0
let g:Tex_GotoError = 0
let g:Tex_AdvancedMath = 1
let g:Tex_Env_{'figure'} =
\"\\begin{figure}\<CR>\\centering\<CR>\\includegraphics[width=\\textwidth]{<+eps filename+>}
\\<CR>\\caption{<+caption text+>}\<CR>\\label{fig:<+label+>}\<CR>\\end{figure}<++>"
let g:Tex_Env_{'frame'} = "\\begin{frame}{<+Title+>}\<CR><+Content+>\<CR>\\end{frame}"
autocmd BufNewFile,BufRead *.tex call IMAP('EFR', g:Tex_Env_frame,'tex')
nnoremap <SID>fuck_this_stupid_keybind <Plug>IMAP_JumpForward
let c='a'
while c <= 'z'
    exec "set <A-".c.">=\e".c
    exec "imap \e".c." <A-".c.">"
    let c = nr2char(1+char2nr(c))
endw
set timeout ttimeoutlen=50
augroup MyIMAPs
        au!
        au VimEnter * call IMAP('EFE', "\\begin{frame}\<CR>\\setbeamercovered{dynamic}\<CR>\\frametitle{<++>}\<CR><++>\<CR>\\end{frame}<++>", 'tex')
augroup END

" Compile with LuaLaTex by default and set up Okular forward search
let g:Tex_CompileRule_pdf = 'lualatex -synctex=1 -file-line-error -interaction=nonstopmode $*'
let g:Tex_ViewRule_pdf = 'okular --unique'
function! SyncTexForward()
	let s:syncfile = fnamemodify(fnameescape(Tex_GetMainFileName()), ":r").".pdf"
	let execstr = "silent !okular --unique '".s:syncfile."\\#src:".line(".").expand("%\:p")."' &>/dev/null"
	exec execstr | redraw!
endfunction

" Spell Check toggle
let g:myLangList=["nospell","de_de","en_gb"]
let g:myLang=0
function! ToggleSpell()
	let g:myLang=g:myLang+1
	if g:myLang>=len(g:myLangList) | let g:myLang=0 | endif
	if g:myLang==0
		setlocal nospell
	else
		execute "setlocal spell spelllang=".get(g:myLangList, g:myLang)
	endif
	echo "spell checking language:" g:myLangList[g:myLang]
endfunction

" End of plugins

" set gui specific settings
if has('gui_running')
	set background=dark
	colorscheme solarized
	set guioptions-=m
	set guioptions-=T
	set guioptions-=r
	set guioptions-=L
	set mouse=c
	set guifont=Source\ Code\ Pro\ for\ Powerline\ Semi-Bold\ 10
	set tw=0
else
    colorscheme zenburn
endif

" keymaps
" leader
let mapleader = " "
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h
nnoremap <leader>zz :let &scrolloff=999-&scrolloff<CR>
noremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
noremap <leader>p :YcmCompleter GetDoc<CR>
nnoremap <leader>j :wa<CR> :!clear<CR> :make<CR>
nnoremap <leader>k :cclose<CR>:pclose<CR> :lclose<CR>
noremap <F2> :NERDTreeTabsToggle<CR>
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>:YcmCompleter ClearCompilationFlagCache<CR>
noremap <silent><leader><F2> :call ToggleNerdTreeSync()<CR>
noremap <silent><F3> :call ToggleSpell()<CR>
nmap <leader>ds :%s/\s\+$//e<CR>
noremap k gk
noremap j gj
noremap 0 g0
noremap $ g$
noremap ^ g^
noremap gk k
noremap gj j
noremap g0 0
noremap g$ $
noremap g^ ^

" Quickfix
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" .vimrc specific settings
au BufNewFile,BufRead *.vimrc map <buffer> <leader>r :w<CR>:so%<CR>

" Latex specific settings
au BufNewFile,BufRead *.tex  call SetTex()
function! SetTex()
	set tabstop=2
	set softtabstop=2
	set shiftwidth=2
	set colorcolumn=80
	set expandtab
    set tw=0
	let b:AutoPairs = {'(':')', '[':']', '{':'}'}
	map <buffer> <leader>e <F5>
	imap <buffer> <C-e> <F5>
	map <buffer> <leader><S-e> <S-F5>
	imap <buffer> <C-f> <F7>
	nnoremap <buffer> <leader>d <F9>
	imap <buffer> <C-Space> <F9>
	nnoremap <buffer> <Leader>r :call SyncTexForward()<CR>
	nnoremap <buffer> <leader>f :update!<CR>:silent call Tex_RunLaTeX()<CR>
    nnoremap <leader>j :wa<CR> :!clear<CR> :!make<CR>
	call IMAP('`w', '\omega', 'tex')
endfunction

" Python specific settings
let python_highlight_all=-114
au Filetype python call SetPython()
function! SetPython()
	set tabstop=4
	set softtabstop=4
	set shiftwidth=4
	"set textwidth=79
	set colorcolumn=80
	set expandtab
	set foldmethod=indent
	set foldlevel=99
	set fileformat=unix
	map <buffer> <leader>r :w<CR>:!clear<CR>:!python %<CR>
	map <buffer> <leader>f :w<CR>:!clear<CR>:!python %<CR>
endfunction

" mark/remove annoying whitespaces
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c*,*.h,*.vimrc match BadWhitespace /\s\+$/
au BufWritePre *.py :%s/\s\+$//e

" virtualenv support
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
	project_base_dir = os.environ['VIRTUAL_ENV']
	activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
	execfile(activate_this, dict(__file__=activate_this))
EOF
" end of python specific settings
"
" C-family specific settings
au BufNewFile,BufRead *.c,*.cpp,*.h call SetCFam()
function! SetCFam()
	set tabstop=4
	set shiftwidth=4
	set expandtab
	set foldmethod=syntax
	set foldlevel=99
	nnoremap <buffer> <leader>f :w<CR>:!clear<CR>:!g++ "%" -std=c++11 -fopenmp<CR>
	nnoremap <buffer> <leader>r :!clear<CR>:!./a.out<CR>
	inoremap <expr> <enter> getline('.') =~ '^\s*//' ? '<enter><esc>S' : '<enter>'
	nnoremap <expr> O getline('.') =~ '^\s*//' ? 'O<esc>S' : 'O'
	nnoremap <expr> o getline('.') =~ '^\s*//' ? 'o<esc>S' : 'o'
endfunction

" Arduino specific settings
au BufNewFile,BufRead *.ino call SetArduino()
function! SetArduino()
    set filetype=cpp
	set tabstop=4
	set shiftwidth=4
	set expandtab
	set foldmethod=syntax
	set foldlevel=99
	nnoremap <buffer> <leader>f :w<CR>:!clear<CR>:make upload<CR><CR><CR>
	nnoremap <buffer> <leader>r :w<CR>:!clear<CR>:make monitor<CR><CR><CR>
    let g:NERDCustomDelimiters = { 'ino': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' } }
endfunction
