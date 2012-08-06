let s:save_cpo = &cpo
set cpo&vim
scriptencoding utf-8

function! reanimate#events#message#define()
	return s:event
endfunction


let s:event = {
\	"name" : "reanimate_message"
\}


function! s:event.save_failed(context)
	echoerr "== reanimate.vim == ".a:context.point." Save Failed!! : ".a:context.exception
endfunction

function! s:event.load_failed(context)
	echoerr "== reanimate.vim == ".a:context.point." Load Failed!! : ".a:context.exception
endfunction

function! s:event.load_leave(context)
	let input = input("Do you want to save the ".reanimate#last_point()."? [y/n]:")
	if input == "y"
		call reanimate#save(reanimate#last_point())
	elseif input != "n"
" 			echom "Canceled"
		throw "Canceled"
	endif
endfunction

function! s:event.save_leave(context)
	let input = input("Overwrite the ".a:context.point."? [y/n]:")
	if input != "y"
" 			echom "No Saved"
		throw "Canceled"
	endif
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
