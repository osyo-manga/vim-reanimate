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
	return get(g:, "reanimate_vimrc_local_filename", "vimrc_local")
endfunction


function! s:vimrc_local(loc, filename)
	let files = findfile(a:filename, escape(a:loc, ' ') . ';', -1)
	for i in reverse(filter(files, 'filereadable(v:val)'))
		source `=i`
	endfor
endfunction

function! s:event.load_pre(context)
	call s:vimrc_local(a:context.path, s:vimrc_local_filename(). "_pre.vim")
endfunction

function! s:event.load(context)
	call s:vimrc_local(a:context.path, s:vimrc_local_filename().".vim")
endfunction

function! s:event.load_post(context)
	call s:vimrc_local(a:context.path, s:vimrc_local_filename()."_post.vim")
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
