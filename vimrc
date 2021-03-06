"------------------------ Function definitions ------------------------
" Creates the specified directory if doesn't exist.
" @param dirpath The directory path
function s:mkdir(dirpath)
  if !isdirectory(a:dirpath)
    call mkdir(expand(a:dirpath), 'p')
  endif
endfunction

" Sets value to option variable
" @param option Option name like: backupdir
" @param valu   Value to set to the specified option
function s:setoption(option, value)
  execute 'set ' . a:option . '=' . a:value
endfunction


"------------------------ Basic directories ------------------------
let s:cache_dir  = expand('~/.vim/cache')
let s:tmp_dir    = expand('~/.vim/tmp')
let s:bundle_dir = expand('~/.vim/bundles')
" check if directories exist and create it
call s:mkdir(s:tmp_dir)
call s:mkdir(s:cache_dir)
call s:mkdir(s:bundle_dir)
" set auto output files directory
call s:setoption('directory', s:tmp_dir)
call s:setoption('backupdir', s:tmp_dir)
call s:setoption('viminfo+', 'n~/.vim/viminfo')


"------------------------ Basic settings ------------------------
let s:colorscheme_plugin = 'jacoborus/tender'
set number                        " display line number
set whichwrap=b,s,h,l,<,>,[,],~   " automatically wrap left and right
set tabstop=2                     " tab width
set shiftwidth=2
set backspace=start,eol,indent    " backspace and delete problems
set cursorline                    " hightlite cursor line
set ambiwidth=double              " for double-byte character
set t_Co=256
" bash like completion method
set wildmenu
set wildignorecase
set wildmode=longest,list


"------------------------ Plugin settings ------------------------
" Set up dein plugin manager
let s:dein_path = s:bundle_dir . '/dein.vim'
if &compatible
  set nocompatible
endif
call s:setoption('runtimepath+', s:dein_path)
if dein#load_state(s:bundle_dir)
  call dein#begin(s:bundle_dir)
  call dein#add(s:dein_path)

  " status line
  call dein#add('itchyny/lightline.vim')
  " Colorscheme
  call dein#add(s:colorscheme_plugin . '.vim')

  call dein#add('tyru/caw.vim')

  call dein#end()
  call dein#save_state()
endif
filetype plugin indent on
if dein#check_install()
  call dein#install()
endif
syntax on
execute 'colorscheme ' . split(s:colorscheme_plugin, '/')[1]


"------------------------ lightline and tabline setup ------------------------
" Returns current buffer name.
" This function uses fnamebody()
" @param mods 2nd argument for fnamemodify()
" @return     Current buffer name
function! g:LL_getCurrentBufferName(mods)
  let n = tabpagenr()
  let bufnrs = tabpagebuflist(n)
  let curbufnr = bufnrs[tabpagewinnr(n) - 1]
  let fname = bufname(curbufnr)
  let path = fnamemodify(fname, a:mods)
  return path
endfunction
" activate and basic settings
set noshowmode
set laststatus=2
set showtabline=2
set guioptions-=e
" customize lightline
let g:lightline = {'colorscheme': 'wombat'}
let g:lightline.component = {
  \ 'bufpath': '%{g:LL_getCurrentBufferName(:~)}',
  \ 'bufdir': '%{g:LL_getCurrentBufferName(":~:h")}'
\ }
let g:lightline.tabline = {
  \ 'right': [['bufdir']]
\ }
let g:lightline.tab = {
  \ 'active': ['filename', 'modified'],
  \ 'inactive': ['filename', 'modified']
\ }


highlight Visual ctermbg=LightGray guibg=LightGray

" toggle comment
nmap <C-\> <Plug>(caw:hatpos:toggle)
imap <C-\> <ESC><Plug>(caw:hatpos:toggle)a
vmap <C-\> <Plug>(caw:hatpos:toggle)
" move to head
nnoremap <C-a> ^
inoremap <C-a> <ESC>^i
" move to tail
nnoremap <C-e> $
inoremap <C-e> <ESC>$a
