let s:save_cpo = &cpo
set cpo&vim
scriptencoding utf-8


let g:reanimate#events#session#enable_force_source = get(g:, "reanimate#events#session#enable_force_source", 0)


function! reanimate#events#session#define()
	return s:event
endfunction


function! s:errormsg(str)
	echohl ErrorMsg
	try
		for text in split(a:str, "\n")
			echom text
		endfor
	finally
		echohl NONE
	endtry
endfunction



let s:event = {
\	"name" : "reanimate_session"
\}


function! s:event.load(context)
	let dir = a:context.path
	if filereadable(dir."/session.vim")
		if g:reanimate#events#session#enable_force_source
			redir => error
				silent! source `=dir."/session.vim"`
			redir END
			call s:errormsg(error)
		else
			source `=dir."/session.vim"`
		endif
	endif
endfunction

function! s:event.save(context)
	let dir = a:context.path
	let tmp = &sessionoptions
	try
		let &sessionoptions = g:reanimate_sessionoptions
		if !filereadable(dir.'/session.vim') || filewritable(dir.'/session.vim')
			execute "mksession! ".dir."/session.vim"
		endif
	finally
		let &sessionoptions = tmp
	endtry
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo
