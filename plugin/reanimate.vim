if exists('g:loaded_reanimate')
  finish
endif
let g:loaded_reanimate = 1

let s:save_cpo = &cpo
set cpo&vim


" global variable
let g:reanimate_save_dir          = get(g:, "reanimate_save_dir", expand("~/reanimate/save_dir"))
let g:reanimate_default_save_name = get(g:, "reanimate_default_save_name", "latest")
let g:reanimate_sessionoptions    = get(g:, "reanimate_sessionoptions", &sessionoptions)
let g:reanimate_disables          = get(g:, "reanimate_disables", [])



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
