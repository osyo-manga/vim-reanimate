let s:save_cpo = &cpo
set cpo&vim
scriptencoding utf-8

function! reanimate#events#error#define()
	return s:event
endfunction


let s:event = {
\	"name" : "reanimate_error"
\}


function! s:event.save_failed(context)
	echoerr "== reanimate.vim == ".a:context.point." Save Failed!! : ".a:context.exception
endfunction

function! s:event.load_failed(context)
	echoerr "== reanimate.vim == ".a:context.point." Load Failed!! : ".a:context.exception
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
