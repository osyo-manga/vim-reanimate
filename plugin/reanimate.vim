if exists('g:loaded_reanimate')
  finish
endif
let g:loaded_reanimate = 1

let s:save_cpo = &cpo
set cpo&vim


function! s:save_point_completelist(arglead, ...)
	return filter(reanimate#save_points(), "v:val =~? '".a:arglead."'")
endfunction

command! -nargs=? -complete=customlist,s:save_point_completelist
\	ReanimateSave
\	call reanimate#save(<f-args>)

command!
\	ReanimateSaveCursorHold
\	if s:is_saved() | call reanimate#save(<f-args>) | endif

command!
\	ReanimateSaveInput
\	call reanimate#save(input("Input SavePoint Name:"))


command! -nargs=? -complete=customlist,s:save_point_completelist
\	ReanimateLoad
\	:call reanimate#load(<f-args>)

command!
\	ReanimateLoadInput
\	call reanimate#load(input("Input SavePoint Name:"))



let &cpo = s:save_cpo
unlet s:save_cpo
