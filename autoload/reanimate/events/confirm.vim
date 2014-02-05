let s:save_cpo = &cpo
set cpo&vim
scriptencoding utf-8

function! reanimate#events#confirm#define()
	return s:event
endfunction


let s:event = {
\	"name" : "reanimate_confirm"
\}

function! s:event.load_leave(context)
	let input = input("Do you want to save the ".reanimate#last_point()."? [y/n]:")
	if input == "y"
		call reanimate#save(reanimate#last_point())
	elseif input != "n"
		throw "Canceled"
	endif
endfunction

function! s:event.save_leave(context)
	let input = input("Overwrite the ".a:context.point."? [y/n]:")
	if input != "y"
		throw "Canceled"
	endif
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
