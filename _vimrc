" Modeline and Notes {{{1
"   vim: fdm=marker:ts=4
"   vim: set foldlevel=0
"
"   This is my personal _vimrc, Last updated at
"   03/15/2011
" }}}

" Basics {{{1
    set nocompatible " explicitly get out of vi-compatible mode
    syntax on " syntax highlighting on
" }}}


" {{{1 General Settings
    filetype plugin indent on " load filetype plugins/indent settings
    " set autochdir  " always switch to the current file directory @03/16/2011, see key mapping <leader>cd
    set backspace=indent,eol,start  " backspacing over everything in insert mode
    set backup  " make backup files
    set backupdir=$VIM/vimfiles/backup " where to put backup files
    set nowritebackup " do not keep backup file when write
    set iskeyword+=_,$,@,%,#  " none of these chars should be word dividers
    set mouse=a  " enable the use of the mouse
    set noerrorbells " don't make noise
    set whichwrap=b,s,h,l,<,>,~,[,]       " everything wraps
    "             | | | | | | | | |
    "             | | | | | | | | +-- "]" Insert and Replace
    "             | | | | | | | +-- "[" Insert and Replace
    "             | | | | | | +-- "~" Normal
    "             | | | | | +-- <Right> Normal and Visual
    "             | | | | +-- <Left> Normal and Visual
    "             | | | +-- "l" Normal and Visual (not recommended)
    "             | | +-- "h" Normal and Visual (not recommended)
    "             | +-- <Space> Normal and Visual
    "             +-- <BS> Normal and Visual
    set wildmenu " command-line completion in an enhanced mode
    " ignore these list file extensions
    set wildignore=*.bak,*.o,*.e,*~,*.pyc,
                    \*.jpg,*.gif,*.png 
    set wildmode=list:longest " turn on wild mode huge list
" }}}

" Vim UI {{{1
    set cursorcolumn " highlight the current column
    set cursorline " highlight current line
    set incsearch " do incremental searching
    set laststatus=2 " always show the status line
    set lazyredraw " do not redraw while running macros
    set linespace=0 " don't insert any extra pixel lines
                    " between rows

    set listchars=tab:>-,trail:-     " strings to use in 'list' mode
    set hlsearch  " highlight the last used search pattern
    set nostartofline " leave my cursor where it was
    set novisualbell " don't blink
    set ruler " show the cursor position all the time
    set showcmd " display incomplete commands
    set showmatch " show the match brackets
    set linebreak                   " wrap long lines
    
    color zenburn "color theme settings
" }}}

" {{{1 GUI
    if has("gui_running")
      " {{{2 platform independent
      set guioptions-=T "no toolbar 
      set guioptions-=L
      set guioptions-=r
      " }}}
      
      " {{{2 platform dependent
      " {{{3 Windows
      if has("win32")
        set guifont=Consolas:h12:cANSI
        set guifontwide=NSimSun:h12

        "Maximize Window at open
        au GUIEnter * simalt ~x 
      "}}}
      " {{{3 *nix
      elseif has("unix")
        "set guifont=Bitstream\ Vera\ Sans\ Mono\ 12
        set guifont=Consolas\ 12
        set guifontwide=
      "}}}
      " {{{3 Mac (empty)
      elseif has("mac") || has("macunix")
        set guifont=
        set guifontwide=
      endif
      "}}}
    endif 
    "}}}
"}}}

" Text Formatting/Layout {{{1
    set expandtab " expand TAB with spaces
    set formatoptions=rq "Automatically insert comment leader on return,
                            " and let gq format comments
    set shiftwidth=4 " number of spaces to use for each step of indent
    set tabstop=4 " number of spaces that a <Tab> counts for

    set foldenable " Turn on folding
    set foldlevel=100 " Don't autofold anything

    if has("autocmd") 
        " open file with cursor at last edit place 
        autocmd BufReadPost * 
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal g`\"" |
            \ endif

        " set line number with source files only.
        autocmd Filetype 
            \ c,cpp,python,perl,
            \tex,cu,vim,sh,
            \gnuplot,
            \vhdl,verilog 
            \ set number

        " associate .gpi with gnuplot
        autocmd BufNewFile,BufRead *.gpi  set filetype=gnuplot
    endif 
" }}}

" {{{1 misc settings 
    set autoindent                  " copy indent from current line
    set autoread                    " read open files again when changed outside Vim
    set autowrite                   " write a modified buffer on each :next , ...
    set browsedir=current           " which directory to use for the file browser
    set complete+=k                 " scan the files given with the 'dictionary' option
    set history=50                  " keep 50 lines of command line history
    "set nowrap                      " do not wrap lines
    set popt=left:8pc,right:3pc     " print options
    set smartindent                 " smart autoindenting when starting a new line
    set t_Co=256                    " using 256 colors
    set viminfo='20,\"50            " 
    if has('autocmd')
        autocmd GUIEnter * set vb t_vb=
    endif

    if has("unix") " dictionary&spell checking
      set dictionary+=/usr/share/dict/words
      set thesaurus+=/home/lw2aw/mthesaur.txt
    endif 

    set ofu=syntaxcomplete#Complete " turn on omnicompletion

    " visual mode search (from ultimate vimrc) {{{2
    " In visual mode when you press * or # to search for the current selection
    vnoremap <silent> * :call VisualSearch('f')<CR>
    vnoremap <silent> # :call VisualSearch('b')<CR>

    " When you press gv you vimgrep after the selected text
    vnoremap <silent> gv :call VisualSearch('gv')<CR>
    map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>


    function! CmdLine(str)
        exe "menu Foo.Bar :" . a:str
        emenu Foo.Bar
        unmenu Foo
    endfunction

    " From an idea by Michael Naumann
    function! VisualSearch(direction) range
        let l:saved_reg = @"
        execute "normal! vgvy"

        let l:pattern = escape(@", '\\/.*$^~[]')
        let l:pattern = substitute(l:pattern, "\n$", "", "")

        if a:direction == 'b'
            execute "normal ?" . l:pattern . "^M"
        elseif a:direction == 'gv'
            call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
        elseif a:direction == 'f'
            execute "normal /" . l:pattern . "^M"
        endif

        let @/ = l:pattern
        let @" = l:saved_reg
    endfunction
    " }}}
"}}}

" {{{1 key mappings (general)
    
    " map ESC
    imap <C-e> <ESC>
    
    " map leader
    let mapleader = ","
    let g:mapleader = ","

    "quickfix
    noremap <leader>n :cn<cr>
    noremap <leader>p :cp<cr>

    " smart way to move between windows
    noremap <C-j> <C-W>j
    noremap <C-k> <C-W>k
    noremap <C-h> <C-W>h
    noremap <C-l> <C-W>l

    " close current buffer {{{
    noremap <leader>bd :Bclose<cr>
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
    "}}}

    " tab manipulation
    noremap <leader>tn :tabnew<cr>
    noremap <leader>te :tabedit
    noremap <leader>tc :tabclose<cr>
    noremap <leader>tm :tabmove

    " switch to the dirctory of current open buffer
    noremap <leader>cd :cd %:p:h<cr>

    " spell check {{{
    noremap <leader>ss :setlocal spell!<cr> " toggle and untoggle spell checking
    map <leader>sn ]s
    map <leader>sp [s
    map <leader>sa zg
    map <leader>s? z=
    " }}}

    noremap <leader>pp :setlocal paste!<cr> " toggle paste

    " Fold/unfold with <space>
    set foldenable
    nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
"}}}

" {{{1 Plugin Settings
" {{{2 scons 
if has("autocmd")
  au BufNewFile,BufRead *SCons* set filetype=python
endif " has("autocmd")
"}}}
" {{{2 c.vim (and other c/c++ settings)
if has("autocmd")
  autocmd FileType c,cpp set foldmethod=syntax
  autocmd FileType c,cpp set foldlevel=100
  autocmd FileType c,cpp set cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
  autocmd Filetype c,cpp set shiftwidth=4
endif " has("autocmd")
"}}}
" {{{2 cscope 
"   @Todo: refine the mappings to be easier to type
set cscopequickfix=s-,g-,c-,d-,i-,t-,e-
nnoremap <leader>css :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>csg :cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>csc :cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>cst :cs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>cse :cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>csf :cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <leader>csi :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nnoremap <leader>csd :cs find d <C-R>=expand("<cword>")<CR><CR>
"-------------------------------------------------------------------------------
" {{{2 NerdTree.vim 
noremap  <silent> <F12>  <Esc><Esc>:NERDTreeToggle<CR>
inoremap <silent> <F12>  <Esc><Esc>:NERDTreeToggle<CR>
"}}}
" {{{2 taglist.vim 
noremap  <silent> <F11>  <Esc><Esc>:Tlist<CR>
inoremap <silent> <F11>  <Esc><Esc>:Tlist<CR>

let Tlist_tex_settings = 'latex;s:sections;g:graphics;l:labels'
let Tlist_make_settings  = 'make;m:makros;t:targets'
let Tlist_qmake_settings = 'qmake;t:SystemVariables'

"show tag for one file only
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Use_Right_Window=1

if has("unix")
  let Tlist_Ctags_Cmd='/home/lw2aw/mytools/ctags/bin/ctags'
endif " has("unix")

"-------------------------------------------------------------------------------
" {{{2 cuda syntax
if has("autocmd")
  " ----------  CUDA : set filetype for *.cu   -----------
  autocmd BufNewFile,BufRead *.cu set filetype=cu
endif " has("autocmd")
"-------------------------------------------------------------------------------
" {{{2 LaTeX
"{{{3 vim-latex 
let g:tex_flavor = "latex" "load Latex-suite when open .tex whatever the content in file

let g:Tex_DefaultTargetFormat="all" " latex-makefile is used

" settinngs from addon's document {{{4
" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*
" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
set iskeyword+=:
" }}}

"let g:Tex_PromptedEnvironments =
"let g:Tex_HotKeyMappings
"let g:Tex_PromptedCommands

" compile and view options in different platforms
if has("win32")
  "windows settings using MikTeX
  let g:Tex_CompileRule_dvi="latex -src-specials -interaction=nonstopmode $*"
  let g:Tex_CompileRule_ps ="dvips -o$*.ps $*.dvi"
  let g:Tex_CompileRule_pdf="dvipdfmx $*.dvi"

  let g:Tex_ViewRule_dvi   = "yap"
  let g:Tex_ViewRule_pdf   = "acrord32"
  let g:Tex_ViewRule_ps    = "ghostscript"
elseif has("unix")
  " *nix settings using texlive
  let g:Tex_CompileRule_dvi="latex -src-specials -interaction=nonstopmode $*"
  let g:Tex_CompileRule_ps ="dvips -o$*.ps $*.dvi"
  let g:Tex_CompileRule_pdf="dvipdfmx $*.dvi"

  let g:Tex_ViewRule_dvi   = "xdvi -editor 'gvim --servername latex-suite --remote-silent'"
  let g:Tex_ViewRule_pdf   = "okular"
  let g:Tex_ViewRule_ps    = "okular"
else " Mac system
  " currently no settings for mac
endif

if has("autocmd")
  autocmd FileType tex set textwidth=78
endif " has("autocmd")

let g:Tex_AutoFolding=0 " disable auto folding when open a file
" }}}
" {{{3 LatexFormatPar.vim (script#2187)
noremap  <leader>lf <ESC>:silent call FormatLatexPar(0)<CR>
noremap! <leader>lf <ESC>:silent call FormatLatexPar(0)<CR>
"}}}
" {{{3 Latex-Box (disabled)
" }}}
"}}}
" {{{2 bash-support.vim (disabled)
"let g:BASH_AuthorName  = 'Liang Wang'
"let g:BASH_Email       = 'lw2aw@virginia.ed'
"let g:BASH_Company     = 'CS@UVa'
"let g:BASH_GlobalTemplateFile = $HOME.'vim-addons\bash-support.vim_-_BASH_IDE\bash-support\templates\Templates'
"}}}
" {{{2 perl-support.vim (disabled)
"let g:Perl_AuthorName  = 'Liang Wang'
"let g:Perl_Email       = 'lw2aw@virginia.ed'
"let g:Perl_Company     = 'CS@UVa'
"let g:Perl_GlobalTemplateFile = $HOME.'vim-addons\perl-support.vim_-_PERL_IDE\perl-support\templates\Templates'
"}}}
" {{{2 Python 
if has("autocmd")
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete

  " general settings for python
  autocmd FileType python setlocal expandtab 
  autocmd FileType python setlocal textwidth=79 
  autocmd FileType python setlocal tabstop=4  
  autocmd FileType python setlocal softtabstop=4 
  autocmd FileType python setlocal shiftwidth=4 
  autocmd FileType python setlocal nosmartindent 
  autocmd FileType python setlocal complete+=k~/.vim/syntax/python.vim isk+=.,(
endif " has("autocmd")
"}}}
" {{{2 vimwiki
let g:vimwiki_list = [{ 'path': '~/public_html/vimwiki',
            \ 'path_html': '~/public_html/vimwiki_html/',
            \ 'html_header': '~/public_html/vimwiki_html/template/header.tpl',
            \ 'html_footer': '~/public_html/vimwiki_html/template/footer.tpl',
            \ 'ext': '.vimwiki'}]
let g:vimwiki_timestamp_format='%m-%d-%Y %H:%M:%S'
"}}}
" supertab {{{2
let g:SuperTabDefaultCompletionType="context"
"}}}
" omnicppcomplete {{{2
let OmniCpp_NamespaceSErach = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview
" }}}
" vcscommand {{{2
let VCSCommandMapPrefix = '<leader>vc'
" }}}
" netrw (disabled) {{{2
    "let g:netrw_scp = 1
    "let g:netrw_scp_cmd = '"d:\mytools\PuTTY\pscp.exe"'
    "let g:netrw_sftp_cmd= '"c:\mytools\PuTTY\psftp.exe"'
" }}}
"}}}

