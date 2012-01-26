let s:save_cpo = &cpo
set cpo&vim

scriptencoding utf-8

function! unite#sources#reanimate#define()
	return s:source
endfunction


function! s:latest_time_str(dir)
	let time = getftime(get(split(globpath(a:dir, "/*"), "\n"), 0, ""))
	return time != -1 && exists("*strftime") ? strftime("(%c)", time) : ""
endfunction

function! s:latest_time(dir)
	let result = s:latest_time_str(a:dir)
" 	let space  = join(map(range(23 - len(result)), "' '"), "")
	let space = repeat(" ", 23 - len(result))
	return result.space
endfunction

let s:source = {
\	"name" : "reanimate",
\	"description" : "reanimate",
\	"syntax" : "uniteSource_reanimate",
\	"hooks" : {},
\	"is_selectable" : 0,
\	"action_table" : {}
\}


function! s:source.hooks.on_syntax(args, context)
	syntax match point /\[\zs.*\ze]/ containedin=uniteSource_reanimate
	highlight point term=bold gui=bold
endfunction


function! s:source.gather_candidates(args, context)
	let new_save = a:context.default_action == "reanimate_save" ? [{
\		"word" : "[new save]",
\		"kind" : "reanimate",
\}]
\ : []
	return new_save + map(reanimate#save_points_path(), '{
\		"word" : s:latest_time(v:val)."[ ".reanimate#path_to_point(v:val)." ]",
\		"kind" : "reanimate",
\		"action__point" : reanimate#path_to_point(v:val),
\		"action__directory"  : v:val
\}')
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
