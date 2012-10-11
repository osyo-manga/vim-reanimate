let s:save_cpo = &cpo
set cpo&vim
scriptencoding utf-8

function! reanimate#events#quickfix#define()
	return s:event
endfunction


let s:event = {
\	"name" : "reanimate_quickfix"
\}


function! s:event.load(context)
	let dir = a:context.path
	if filereadable(dir."/quickfix.vim")
		execute "source ".dir."/quickfix.vim"
	endif
endfunction


function! s:write_quickfix(file, qflist)
	let qflist = a:qflist

	for line in qflist
		if line.bufnr != 0
			let fname = substitute(fnamemodify(bufname(line.bufnr), ":p"), '\\', '/', 'g')
			let line.filename = fname
			unlet line.bufnr
		endif
	endfor
	
	call writefile(
\		  ["call setqflist( ["]
\		+ map(qflist, "'\\'.string(v:val).','")
\		+ ["\\], 'r')"],
\		a:file
\	)
endfunction

function! s:event.save(context)
	let qflist = getqflist()
	let dir = a:context.path
	if !filereadable(dir.'/quickfix.vim') || filewritable(dir.'/quickfix.vim')
		call s:write_quickfix(dir.'/quickfix.vim', qflist)
	endif
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
