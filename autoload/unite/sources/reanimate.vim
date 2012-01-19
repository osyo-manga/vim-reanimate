let s:save_cpo = &cpo
set cpo&vim

scriptencoding utf-8

function! unite#sources#reanimate#define()
	return s:source
endfunction

function! s:latest_time(dir)
	let time = getftime(get(split(globpath(a:dir, "/*"), "\n"), 0, ""))
	return time != -1 && exists("*strftime") ? strftime("(%c)", time) : ""
endfunction

let s:source = {
\	"name" : "reanimate",
\	"description" : "reanimate",
\	"is_selectable" : 0,
\	"action_table" : {}
\}

function! s:source.gather_candidates(args, context)
	let new_save = a:context.default_action == "reanimate_save" ? [{
\		"word" : "[new save]",
\		"kind" : "reanimate",
\}]
\ : []
	return new_save + map(reanimate#save_points_path(), '{
\		"word" : s:latest_time(v:val)."  ".reanimate#path_to_point(v:val),
\		"kind" : "reanimate",
\		"action__point" : reanimate#path_to_point(v:val),
\		"action__directory"  : v:val
\}')
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
