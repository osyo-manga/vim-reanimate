let s:save_cpo = &cpo
set cpo&vim
scriptencoding utf-8

function! reanimate#events#viminfo#define()
	return s:event
endfunction


let s:event = {
\	"name" : "reanimate_viminfo"
\}

function! s:event.load(context)
	let dir = a:context.path
	if filereadable(dir."/viminfo.vim")
		execute "rviminfo ".dir."/viminfo.vim"
	endif
endfunction

function! s:event.save(context)
	let dir = a:context.path
	if !filereadable(dir.'/viminfo.vim') || filewritable(dir.'/viminfo.vim')
		execute "wviminfo!  ".dir."/viminfo.vim"
	endif
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
