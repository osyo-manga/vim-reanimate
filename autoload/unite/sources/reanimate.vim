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

	let category = get(a:args, 0, "")
	if empty(category)
		return new_save + map(sort(map(reanimate#save_points_path(), '{
\			"time"  : reanimate#latest_time(reanimate#path_to_category_point(v:val)),
\			"point" : reanimate#path_to_category_point(v:val),
\			"path"  : v:val,
\		}'), "s:time_sorter"),
\		'{
\			"word" : s:time_to_string(v:val.time)."  [ ".v:val.point." ]",
\			"kind" : "reanimate",
\			"action__point" : v:val.point,
\			"action__path"  : v:val.path,
\			"action__directory" : v:val.path
\		}')
	else
		return new_save + map(sort(map(reanimate#save_points_path(category), '{
\			"time"  : reanimate#latest_time(reanimate#path_to_category_point(v:val)),
\			"category_point" : reanimate#path_to_point(v:val),
\			"point" : reanimate#path_to_category_point(v:val),
\			"path"  : v:val,
\		}'), "s:time_sorter"),
\		'{
\			"word" : s:time_to_string(v:val.time)."  [ ".v:val.point." ]",
\			"kind" : "reanimate",
\			"action__point" : v:val.category_point,
\			"action__path"  : v:val.path,
\			"action__directory" : v:val.path
\		}')

	endif
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
