let s:save_cpo = &cpo
set cpo&vim

scriptencoding utf-8

function! unite#sources#reanimate#define()
	return s:source
endfunction

function! s:time_format()
	return "(%Y/%m/%d %H:%M:%S)"
endfunction

function! s:time_to_string(time)
	return a:time != -1 && exists("*strftime") ? strftime(s:time_format(), a:time) : ""
endfunction

function! s:latest_time_str(dir)
	return s:time_to_string(getftime(a:dir))
endfunction

function! s:latest_time(dir)
	return sort(map(split(globpath(a:dir, "*"), "\n"), "getftime(v:val)"))[-1]
" 	return s:latest_time_str(a:dir)
endfunction

let s:source = {
\	"name" : "reanimate",
\	"description" : "reanimate",
\	"syntax" : "uniteSource_reanimate",
\	"hooks" : {},
\	"is_selectable" : 0,
\	"action_table" : {},
\}


function! s:time_sorter(a, b)
	return a:a.time < a:b.time ? 1 : -1
endfunction

function! s:source.gather_candidates(args, context)
	let new_save = a:context.default_action == "reanimate_save" ? [{
\		"word" : "[new save]",
\		"kind" : "reanimate",
\	}]
\ : []

	return new_save + map(sort(map(reanimate#save_points_path(), '{
\		"time"  : s:latest_time(v:val),
\		"point" : reanimate#path_to_point(v:val),
\		"path"  : v:val,
\	}'), "s:time_sorter"),
\	'{
\		"word" : s:time_to_string(v:val.time)."  [ ".v:val.point." ]",
\		"kind" : "reanimate",
\		"action__point" : v:val.point,
\		"action__path"  : v:val.path,
\		"action__directory" : v:val.path
\}')
endfunction

function! s:source.hooks.on_syntax(args, context)
" 	syntax clear

	syntax match uniteSource__Reanimate_Time
		\ /\s\+\zs([^)]*)/ contained containedin=uniteSource_reanimate
	highlight default link uniteSource__Reanimate_Time Statement

	syntax match uniteSource__Reanimate_Point
		\ /\[\zs.*\ze]/ containedin=uniteSource_reanimate
	highlight uniteSource__Reanimate_Point term=bold gui=bold
endfunction




let &cpo = s:save_cpo
unlet s:save_cpo
