" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'franbach/miramare'

" Plugin 'terryma/vim-multiple-cursors'

Plugin 'cohama/lexima.vim'

Plugin 'airblade/vim-gitgutter'

" Plugin 'valloric/youcompleteme'

Plugin 'itchyny/lightline.vim'

Plugin 'prettier/vim-prettier'

Plugin 'mattn/webapi-vim'

Plugin 'mattn/emmet-vim'

Plugin 'lilydjwg/colorizer'

Plugin 'junegunn/vim-emoji'

Plugin 'evanleck/vim-svelte'

call vundle#end()            " required

set autoindent
set nocompatible                         "don't need to keep compatibility with Vi
filetype plugin on                       "enable detection, plugins and indenting in one step
syntax on                                "Turn on syntax highlighting
set background=dark                      "make vim use colors that look good on a dark background
set showcmd                              "show incomplete cmds down the bottom
set laststatus=2
set noshowmode                             "show current mode down the bottom
set autoindent
set pastetoggle=<F2>
set ignorecase
set smartcase
set noswapfile
set relativenumber

set fdm=indent " set fold method and fold everything
autocmd BufWinEnter * normal zR " unfold everything
" set foldmethod=manual
set showmatch                            "set show matching parenthesis
set number                               "set number
set mouse=a
set backspace=indent,eol,start
set ts=4 sw=4 noet

" incremental search
set incsearch
" highlight all search pattern matches
set hlsearch
" disable highlighting temp
" nohlsearch

" match other things than braces, bracket and paranteces
runtime macros/matchit.vim

" set colorcolumn=20,40,60,80,100

set list
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

au VimEnter * :GitGutterEnable

" navigating splits without ctrl-w
nnoremap ,h :wincmd h<CR>
nnoremap ,l :wincmd l<CR>

" colorscheme
set termguicolors

let g:miramare_enable_italic = 1
let g:miramare_disable_italic_comment = 1

colorscheme miramare

" make vim background same as terminal
hi Normal guibg=NONE ctermbg=NONE

" helpers
function SpacesForIndent(n)
    setlocal expandtab
    let &tabstop=a:n
    let &softtabstop=a:n
    let &shiftwidth=a:n
endfunction
" infer particular settings from contents of file
function SettingsForContent()
    " Determines whether to use spaces or tabs on the current buffer.
    if getfsize(bufname("%")) > 256000
        " File is very large, just use the default.
        " Turn off syntax highlighting too!
        setlocal syntax=off
        return
    endif
    let numTabs=len(filter(getbufline(bufname("%"), 1, 250), 'v:val =~ "^\\t"'))
    let num2Spaces=len(filter(getbufline(bufname("%"), 1, 250), 'v:val =~ "^  [^ ]"'))
    let num4Spaces=len(filter(getbufline(bufname("%"), 1, 250), 'v:val =~ "^    [^ ]"'))
    if max([num2Spaces, num4Spaces]) > numTabs
        if num2Spaces > 0
            call SpacesForIndent(2)
        else
            call SpacesForIndent(4)
        endif
    elseif numTabs > 0
        setlocal noexpandtab
    endif
endfunction
autocmd BufReadPost * call SettingsForContent()
" semantic highlighting
autocmd BufEnter * :syntax sync fromstart
autocmd BufEnter * :let g:semanticUseBackground = 1
" press comma s to toggle semantic highlighting
nnoremap ,s :SemanticHighlightToggle<cr>
" settings for file types
let ext=expand('%:e')
if index(["py", "md", "rs"], ext)!=-1
    call SpacesForIndent(4)
elseif index(["html", "css", "js"], ext)!=-1
    call SpacesForIndent(4)
elseif index(["c", "h", "cpp", "hpp"], ext)!=-1
    setlocal tabstop=2
    setlocal shiftwidth=2
endif
" Emmet
let g:user_emmet_expandabbr_key='<Tab>'
imap <expr> <tab> emmet#expandAbbrIntelligent("<tab>")
let g:user_emmet_settings = webapi#json#decode(join(readfile(expand('~/.vim/snippets/index.json')), "\n"))

" Skeletons templates
augroup templates
  au!
  " read in template files
  autocmd BufNewFile *.* silent! execute '0r $HOME/.vim/skeletons/template.'.expand("<afile>:e")
augroup END

" emoji
" emoji list
" for e in emoji#list()
"   call append(line('$'), printf('%s (%s)', emoji#for(e), e))
" endfor

set completefunc=emoji#complete

function! ReplaceEmoji()
  %s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g
endfunction


" keybindings

nnoremap <silent> <Leader>; :<C-u>call ReplaceEmoji()<CR>
