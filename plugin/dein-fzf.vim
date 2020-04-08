if exists('g:loaded_dein_fzf') | finish | endif
let g:loaded_dein_fzf = 1

if has('nvim') && exists('&winblend') && &termguicolors

  if exists('g:fzf_colors.bg')
    call remove(g:fzf_colors, 'bg')
  endif

  if stridx($FZF_DEFAULT_OPTS, '--border') == -1
    let $FZF_DEFAULT_OPTS .= ' --border'
  endif

  function! FloatingFZF()
    let width = float2nr(&columns * 0.8)
    let height = float2nr(&lines * 0.6)
    let opts = { 'relative': 'editor',
          \ 'style': 'minimal',
          \ 'row': 1,
          \ 'col': (&columns - width) / 2,
          \ 'width': width,
          \ 'height': height }

    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
  endfunction

  let g:fzf_layout = { 'window': 'call FloatingFZF()' }
endif

function! s:dein_fzf_install_action(path)
  let l:plugin = split(a:path)[3].'/'.split(a:path)[0]
  let l:choice = confirm('Are you sure you want to install '.substitute(l:plugin, '\n\+$', '', '').'?', "&Yes\n&No", 1)
  if l:choice == 1
    call dein#direct_install(substitute(l:plugin, '\n\+$', '', ''))
    call dein#recache_runtimepath()
  else
    echo 'Nothing will install.'
  endif

endfunction

let s:dein_fzf_install_source = readfile(resolve(expand("<sfile>:p:h"))."/../vim-plugins.txt")

function! s:dein_fzf_install()
  call fzf#run({
        \ 'source': s:dein_fzf_install_source,
        \ 'sink':   function('s:dein_fzf_install_action'),
        \ 'options': '-m --exact',
        \ 'window':  'call FloatingFZF()' })
endfunction

function! s:dein_fzf_list_source()
  let s:list = []
  for p in keys(dein#get())
    call add(s:list, tolower(dein#get()[p].repo))
  endfor
  return sort(s:list)
endfunction

function! s:help_file(item)
  let l:doc_dir_path = g:dein#_base_path.'/repos/github.com/'.a:item.'/doc'
  let l:doc_file_path = system('find '.l:doc_dir_path.' -type f -name "*.txt" 2> /dev/null | head -1')
  execute 'silent h' fnamemodify(l:doc_file_path, ':t')
endfunction

function! s:dein_fzf_list()
call fzf#run({
      \ 'source': s:dein_fzf_list_source(),
      \ 'sink':   function('s:help_file'),
      \ 'options': '--prompt \ \ Installed\ Plugins:\ ',
      \ 'window':    'call FloatingFZF()' })
endfunction

command! DeinFZFInstall call s:dein_fzf_install()
command! DeinFZFList call s:dein_fzf_list()
