let s:save_cpo = &cpo
set cpo&vim

scriptencoding utf-8

function! unite#sources#reanimate#define()
	return s:source
endfunction

function! s:time_format()
	return "(%Y/%m/%d %H:%M:%S)"
endfunction

function! s:latest_time_str(dir)
	let time = getftime(a:dir)
	return time != -1 && exists("*strftime") ? strftime(s:time_format(), time) : ""
endfunction

function! s:latest_time(dir)
	return s:latest_time_str(a:dir)
endfunction

let s:source = {
\	"name" : "reanimate",
\	"description" : "reanimate",
\	"syntax" : "uniteSource_reanimate",
\	"hooks" : {},
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
\		"word" : s:latest_time(v:val)."  [ ".reanimate#path_to_point(v:val)." ]",
\		"kind" : "reanimate",
\		"action__point" : reanimate#path_to_point(v:val),
\		"action__path"  : v:val,
\		"action__directory" : v:val
\}')
endfunction

function! s:source.hooks.on_syntax(args, context)
	syntax clear
	syntax match uniteSource__Reanimate_Point
		\ /\[\zs.*\ze]/ containedin=uniteSource_reanimate
	highlight uniteSource__Reanimate_Point term=bold gui=bold

	syntax match uniteSource__Reanimate_Time
		\ /\s\+\zs([^)]*)/ contained containedin=uniteSource_reanimate
	highlight default link uniteSource__Reanimate_Time Statement
endfunction




let &cpo = s:save_cpo
unlet s:save_cpo
