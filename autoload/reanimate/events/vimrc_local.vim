let s:save_cpo = &cpo
set cpo&vim
scriptencoding utf-8

function! reanimate#events#vimrc_local#define()
	return s:event
endfunction


let s:event = {
\	"name" : "reanimate_vimrc_local"
\}


function! s:vimrc_local_filename()
	return get(g:, "reanimate_vimrc_local_filename", "vimrc_local.vim")
endfunction


function! s:vimrc_local(loc)
	let files = findfile(s:vimrc_local_filename(), escape(a:loc, ' ') . ';', -1)
	for i in reverse(filter(files, 'filereadable(v:val)'))
		source `=i`
	endfor
endfunction

function! s:event.load_post(context)
	call s:vimrc_local(a:context.path)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
