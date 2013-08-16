let s:save_cpo = &cpo
set cpo&vim
scriptencoding utf-8



" reanimate#hook(event)
" or
" reanimate#hook(Funcref, name, event_name)
function! reanimate#hook(event, ...)
	let event = a:0 == 0 ? a:event
\			  : a:0 == 2 ? { "name" : a:1, a:event : a:2 }
\			  :            { "name" : "",  a:event : a:1 }

	call s:events.add(event)
" 	call call(s:events.add, [a:event] + a:000, s:events)
endfunction


function! s:has_category(point)
	let index = match(a:point, "/")
	return index != -1 && index != (len(a:point)-1) && index != 0
endfunction

function! s:get_category(point)
	return s:has_category(a:point)
\		 ? matchstr(a:point, '\zs.*\ze/.*')
\		 : g:reanimate_default_category
endfunction


function! s:point_to_category_point(point)
	return s:has_category(a:point)
\		 ? a:point
\		 : g:reanimate_default_category . "/" . substitute(a:point, '/', '', 'g')
endfunction

function! reanimate#point_to_path(point)
	return s:save_dir()."/".s:point_to_category_point(a:point)
endfunction

function! reanimate#path_to_point(path)
	return namemodify(a:path, ":t")
endfunction

function! reanimate#path_to_category_point(path)
	return fnamemodify(a:path, ":h:t")."/".fnamemodify(a:path, ":t")
endfunction

function! reanimate#path_to_category(path)
	return fnamemodify(a:path, ":h:t")
endfunction

function! reanimate#latest_time(point)
	return get(sort(map(split(globpath(reanimate#point_to_path(a:point), "*"), "\n"), "getftime(v:val)")), -1, "")
endfunction


function! s:time_sorter(a, b)
	return a:a.time < a:b.time ? 1 : -1
endfunction


function! reanimate#latest_save_category_point(...)
	let category = get(a:, 1, "*")
	return get(sort(map(reanimate#save_category_points(category), '{
\		"time"  : reanimate#latest_time(v:val),
\		"point" : v:val,
\	}'), "s:time_sorter"), 0, {"point" : ""}).point
endfunction


function! reanimate#latest_save_point(...)
	let category = get(a:, 1, "*")
	return reanimate#path_to_point(reanimate#latest_save_category_point(category))
endfunction


function! reanimate#categories()
	return map(filter(split(globpath(s:save_dir(), "*"), "\n"), "!s:empty_directory(v:val)"), 'substitute(v:val, "\\", "\/", "g")')
endfunction


function! reanimate#save_points_path(...)
	let category = get(a:, 1, "*")
	return map(filter(split(globpath(s:save_dir(), category."/*"), "\n"), "!s:empty_directory(v:val.'/latest')"), 'substitute(v:val, "\\", "\/", "g")')
endfunction

function! reanimate#save_category_points(...)
	let category = get(a:, 1, "*")
	return map(reanimate#save_points_path(category), "reanimate#path_to_category_point(v:val)")
endfunction

function! reanimate#save_points(...)
	let category = get(a:, 1, "*")
	return map(reanimate#save_points_path(category), "reanimate#path_to_point(v:val)")
endfunction


function! reanimate#save(...)
	let new_point = a:0 && !empty(a:1) ? a:1 : s:last_point()

	" 保存名がないなら何もしないで終了
	if empty(new_point)
		return
	endif

	let new_point = s:point_to_category_point(new_point)
	let context = s:context(new_point)

	" 違うポイントに保存する場合
	let is_another_point = count(reanimate#save_points(), new_point) && new_point != s:last_point()
	if is_another_point
		call s:call_event("save_leave", context)
	endif
	call s:save(context)
	let s:last_point = new_point

	if is_another_point
		call s:call_event("save_enter",context)
	endif
endfunction


function! reanimate#load(...)
	let new_point = a:0 && !empty(a:1) ? a:1 : s:last_point()
	let new_point = s:point_to_category_point(new_point)
	let context = s:context(new_point)
	
	" 違うポイントをロードする場合
	let is_another_point = s:is_saved() && new_point != s:last_point
	if is_another_point
		call s:call_event("load_leave", context)
	endif

	call s:load(context)
	let s:last_point = new_point

	if is_another_point
		call s:call_event("load_enter",context)
	endif
endfunction


function! reanimate#unload()
	let s:last_point = ""
endfunction


function! reanimate#is_saved()
	return s:is_saved()
endfunction

function! reanimate#last_point()
	return s:last_point
endfunction


function! s:rename(from, to)
	if isdirectory(a:to)
		let result = input("Overwrite ". a:to . " ? [yes/no] ")
		if result !=# "yes"
			return
		endif
	endif
	try
		let result= rename(a:from, a:to)
		if result != 0
			echoerr "Failed rename : " . a:from . " => " . a:to
			return
		endif
	catch
		echoerr v:exception
	endtry
	return 1
endfunction


function! reanimate#rename(to, ...)
	let to = a:to
	let from  = get(a:, 1, reanimate#last_point())
	if empty(from) || empty(to)
		echoerr "It is an invalid name."
		return
	endif
	let result = s:rename(reanimate#point_to_path(from), reanimate#point_to_path(to))
	if result && (from == reanimate#last_point())
		let s:last_point = a:to
	endif
endfunction


function! s:setup()
	let s:last_point = ""
	let s:events = s:make_events()
	call s:load_event_define()
endfunction


function! s:save_dir()
	return substitute(g:reanimate_save_dir, "\\", "/", "g")
endfunction

function! s:default_point()
	return g:reanimate_default_save_name
endfunction

function! s:is_saved()
	return !empty(s:last_point)
endfunction

function! s:last_point()
	return empty(s:last_point) ? s:default_point() : s:last_point
endfunction

function! s:disables()
	return g:reanimate_disables
endfunction

function! s:empty_directory(expr)
	return isdirectory(a:expr) ? empty(globpath(a:expr, "*")) : 1
endfunction


function! s:is_disable(event, point)
	if !(type(a:event) == type({}) && has_key(a:event, "name"))
		return 0
	endif
	let _ = copy(get(g:reanimate_event_disables, "_", {}))
	let point = {}
	for key in keys(copy(g:reanimate_event_disables))
		if a:point =~# "^".key."$"
			let point = g:reanimate_event_disables[key]
		endif
	endfor
	let disables = extend(_, point)
	return (len(filter(copy(disables), string(a:event.name)." =~# '^'.v:key.'$' && v:val"))
\		|| count(s:disables(), a:event.name))
\		&& get(disables, a:event.name, 1)
endfunction


function! s:call_event(event, context)
	call s:events.call(a:event, a:context)
endfunction


function! s:load_event_define()
	let event_files = split(globpath(&rtp, "autoload/reanimate/events/*.vim"), "\n")
	for name in map(event_files, "fnamemodify(v:val, ':t:r')")
		call reanimate#hook(reanimate#events#{name}#define())
	endfor
endfunction


function! s:context(point)
	let self = {}
	let self.point        = a:point
" 	let self.path         = reanimate#point_to_path(a:point)."/tmp"
	let self.point_path  = reanimate#point_to_path(a:point)
	return self
endfunction


function! s:make_events()
	let self = {}
	let self.list = []

	function! self.add(event, ...)
		" 既に存在する名前か、"" 以外なら登録しない
		if !count(map(copy(self.list), "v:val.name"), a:event.name) || empty(a:event.name)
			call add(self.list, a:event)
		endif
	endfunction

	function! self.clear()
		let self.list = []
	endfunction

	function! self.call(event, context)
		let context = a:context
		let context.event = a:event
		let list = filter(copy(self.list), "has_key(v:val, a:event) && !s:is_disable(v:val, context.point)")
		if !empty(list)
			call self.call(a:event."_pre", context)
			for var in list
				if type(var[a:event]) == type({}) && has_key(var[a:event], "apply")
					call var[a:event].apply(context)
				else
					call var[a:event](context)
				endif
			endfor
			call self.call(a:event."_post", context)
		endif
	endfunction
	
	return self
endfunction



" Save
function! s:save(context)
	try
		call s:events.call("save", a:context)
	catch
		let a:context.exception = v:exception
		call s:events.call("save_failed", a:context)
	endtry
endfunction


" Load
function! s:load(context)
	try
		call s:events.call("load", a:context)
	catch
		let a:context.exception = v:exception
		call s:events.call("load_failed", a:context)
	endtry
endfunction


call s:setup()



let &cpo = s:save_cpo
unlet s:save_cpo
