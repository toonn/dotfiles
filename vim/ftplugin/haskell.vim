" Tabs
setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal autoindent
setlocal textwidth=79

" neco-ghc
" Disable haskell-vim omnifunc
let g:haskellmode_completion_ghc = 0
setlocal omnifunc=necoghc#omnifunc
autocmd! BufWritePost * Neomake

" haskell-vim-now keybindings

" Hoogle
" Hoogle the word under the cursor
nnoremap <silent> <leader>hh :Hoogle<CR>
" Hoogle and prompt for input
nnoremap <leader>hH :Hoogle 
" Hoogle for detailed documentation (e.g. "Functor")
nnoremap <silent> <leader>hi :HoogleInfo<CR>
" Hoogle for detailed documentation and prompt for input
nnoremap <leader>hI :HoogleInfo 
" Hoogle, close the Hoogle window
nnoremap <silent> <leader>hz :HoogleClose<CR>

" Formatting
" Use hindent instead of par for haskell buffers
let &formatprg="hindent --tab-size 2 -XQuasiQuotes"
" Delete trailing white space on save
" Utility function to delete trailing white space
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
augroup whitespace
  autocmd!
    autocmd BufWrite *.hs :call DeleteTrailingWS()
    augroup END

" Completion, Syntax check, Lint & Refactor
map <silent> <leader><CR> :noh<CR>:GhcModTypeClear<CR>
" Disable hlint-refactor-vim's default keybindings
let g:hlintRefactor#disableDefaultKeybindings = 1
" hlint-refactor-vim keybindings
map <silent> <leader>hr :call ApplyOneSuggestion()<CR>
map <silent> <leader>hR :call ApplyAllSuggestions()<CR>
" Resolve ghcmod base directory
let g:ghcmod_use_basedir = getcwd()
" Type of expression under cursor
nmap <silent> <leader>ht :GhcModType<CR>
" Insert type of expression under cursor
nmap <silent> <leader>hT :GhcModTypeInsert<CR>
" GHC errors and warnings
nmap <silent> <leader>hc :Neomake ghcmod<CR>
" Haskell Lint
nmap <silent> <leader>hl :Neomake hlint<CR>
" Options for Haskell Syntax Check
let g:neomake_haskell_ghc_mod_args = '-g-Wall'
" open the neomake error window automatically when an error is found
let g:neomake_open_list = 2
" Fix path issues from
" vim.wikia.com/wiki/Set_working_directory_to_the_current_file
let s:default_path = escape(&path, '\ ') " store default value of 'path'
" Always add the current file's directory to the path and tags list if not
" already there. Add it to the beginning to speed up searches.
autocmd BufRead *
      \ let s:tempPath=escape(escape(expand("%:p:h"), ' '), '\ ') |
      \ exec "set path-=".s:tempPath |
      \ exec "set path-=".s:default_path |
      \ exec "set path^=".s:tempPath |
      \ exec "set path^=".s:default_path

" Point Conversion
function! Pointfree()
    call setline('.', split(system('pointfree '.shellescape(join(
          \getline(a:firstline, a:lastline), "\n"))), "\n"))
endfunction
vnoremap <silent> <leader>h. :call Pointfree()<CR>

function! Pointful()
    call setline('.', split(system('pointful '.shellescape(join(
          \getline(a:firstline, a:lastline), "\n"))), "\n"))
endfunction
vnoremap <silent> <leader>h> :call Pointful()<CR>

" Automatic tagfile updates for fast-tags
" https://github.com/elaforge/fast-tags/blob/master/vimrc
augroup tags
au BufWritePost *.hs    silent !init-tags %
au BufWritePost *.hsc   silent !init-tags %
augroup end

" fast-tags
" Replace the ^] follow tag command with one that expands a word without
" modifying iskeyword.
if has('python')
  py import sys, os, vim
  py sys.path.insert(0, os.path.join(os.environ['HOME'], '.vim', 'py'))

  py import qualified_tag
  nnoremap <buffer> <silent> <c-]> :py qualified_tag.tag_word(vim)<CR>
endif
