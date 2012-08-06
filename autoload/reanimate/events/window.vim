let s:save_cpo = &cpo
set cpo&vim
scriptencoding utf-8

function! reanimate#events#window#define()
	return s:event
endfunction


let s:event = {
\	"name" : "reanimate_window"
\}


function! s:event.load(context)
	let dir = a:context.path
	if filereadable(dir."/vimwinpos.vim") && has("gui")
		execute "source ".dir."/vimwinpos.vim"
	endif
endfunction

function! s:event.save(context)
	let dir = a:context.path
	if !filereadable(dir.'/vimwinpos.vim') || filewritable(dir.'/vimwinpos.vim')
		if has("gui")
			let options = [
			\ 'set columns=' . &columns,
			\ 'set lines=' . &lines,
			\ 'winpos ' . getwinposx() . ' ' . getwinposy(),
			\ ]
			call writefile(options, dir.'/vimwinpos.vim')
		endif
	endif
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
