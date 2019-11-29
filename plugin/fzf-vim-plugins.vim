function! s:install_plugins(path)
  let l:plugin = split(a:path)[3].'/'.split(a:path)[0]
  let l:choice = confirm('Are you sure you want to install '.substitute(l:plugin, '\n\+$', '', '').'?', "&Yes\n&No", 1)
  if l:choice == 1
    call dein#direct_install(substitute(l:plugin, '\n\+$', '', ''))
  else
    echo 'Nothing will install.'
  endif

endfunction


function! s:fzf_vim_plugins()
  call fzf#run({
        \ 'source': readfile(expand('<sfile>:p:h../vim-plugins.txt')),
        \ 'sink':   function('s:install_plugins'),
        \ 'options': '-m --exact',
        \ 'window':  'call FloatingFZF()' })
endfunction

command! Plugins call s:fzf_vim_plugins()

