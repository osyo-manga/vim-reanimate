let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#reanimate#define()
	return s:kind
endfunction


let s:kind = {
\	"name" : "reanimate",
\	"action_table" : {},
\	"parents" : ["directory"]
\}


let s:kind.action_table.reanimate_new_save = {
\	"description" : "Reanimate New Save",
\	"is_selectable" : 0
\}

function! s:kind.action_table.reanimate_new_save.func(candidate)
	let new_point = input("New Save Name:")
	if new_point != ""
		call reanimate#save(new_point)
	endif
endfunction


let s:kind.action_table.reanimate_save = {
\	"description" : "Reanimate Save",
\	"is_selectable" : 0
\}

function! s:kind.action_table.reanimate_save.func(candidate)
	let new_point = ""
	if has_key(a:candidate, "action__point")
		let new_point = a:candidate.action__point
	else
		let new_point = input("New Save Name:")
	endif
	call reanimate#save(new_point)
endfunction


let s:kind.action_table.reanimate_load = {
\	"description" : "Reanimate Load",
\	"is_selectable" : 0
\}

function! s:kind.action_table.reanimate_load.func(candidate)
	call reanimate#load(get(a:candidate, "action__point", ""))
endfunction


let s:kind.action_table.reanimate_switch = {
\	"description" : "Reanimate Switc",
\	"is_selectable" : 0
\}

function! s:kind.action_table.reanimate_switch.func(candidate)
	silent execute ":ReanimateSwitch" get(a:candidate, "action__point", "")
" 	call reanimate#load(get(a:candidate, "action__point", ""))
endfunction


" let s:kind.action_table.reanimate_delete = {
" \	"description" : "Reanimate Delete Save",
" \	"is_selectable" : 1
" \}
" 
" function! s:kind.action_table.reanimate_delete.func(candidate)
" 	if input("Really force delete save ? [y/n]:") == "y"
" 		for candidate in a:candidate
" 			let point = get(candidate, "action__point", "")
" 			let path  = s:point_to_path(point)
" 			echo, path
" 			if !delete(path)
" 				echom "deleted ".point
" 			endif
" 		endfor
" 	endif
" endfunction



let &cpo = s:save_cpo
unlet s:save_cpo
