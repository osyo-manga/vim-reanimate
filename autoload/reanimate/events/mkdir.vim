let s:save_cpo = &cpo
set cpo&vim
scriptencoding utf-8

function! reanimate#events#mkdir#define()
	return s:event
endfunction


let s:event = {
\	"name" : "reanimate_mkdir"
\}

function! s:event.save_pre(context)
	if !isdirectory(a:context.path)
		call mkdir(a:context.path, "p")
	endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
