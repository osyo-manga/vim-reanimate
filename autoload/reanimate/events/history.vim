let s:save_cpo = &cpo
set cpo&vim
scriptencoding utf-8

function! reanimate#events#history#define()
	return s:event
endfunction


let s:event = {
\	"name" : "reanimate_history"
\}


function! s:event.load_pre_pre(context)
	let a:context.path = a:context.point_path."/latest"
endfunction

function! s:event.load_pre(context)
	" dummy
endfunction

function! s:event.save_pre_pre(context)
	let a:context.path = a:context.point_path."/tmp"
endfunction

function! s:event.save_pre(context)
	" dummy
endfunction

function! s:event.save_post_pre(context)
" 		let history_max = 5
	let latest_path = a:context.point_path."/latest"
	let tmp_path    = a:context.point_path."/tmp"
" 		let histories = split(globpath(a:context.point_path, "*"), "\n")
" 		PP histories
" 		let latest_history_path = histories[0]
" 		echom len(histories)
" 		if isdirectory(latest_path)
" 			let history_path = a:context.point_path."/".getftime(latest_path)
" 			call rename(latest_path, history_path)
" 		endif
" 		call rename(tmp_path, latest_path)
	if !isdirectory(latest_path)
		call mkdir(latest_path)
	endif
	for file in split(globpath(a:context.path, "*"), "\n")
		let filename = fnamemodify(file, ":t")
		call rename(file, latest_path."/".filename)
	endfor
endfunction

function! s:event.save_post(context)
	" dummy
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
