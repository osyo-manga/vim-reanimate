let s:save_cpo = &cpo
set cpo&vim
scriptencoding utf-8

function! reanimate#events#session#define()
	return s:event
endfunction


let s:event = {
\	"name" : "reanimate_session"
\}


function! s:event.load(context)
	let dir = a:context.path
	if filereadable(dir."/session.vim")
		execute "source ".dir."/session.vim"
	endif
endfunction

function! s:event.save(context)
	let dir = a:context.path
	let tmp = &sessionoptions
	execute "set sessionoptions=".g:reanimate_sessionoptions
	if !filereadable(dir.'/session.vim') || filewritable(dir.'/session.vim')
		execute "mksession! ".dir."/session.vim"
	endif
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo
