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
\	"description" : "Reanimate Switch",
\	"is_selectable" : 0
\}

function! s:kind.action_table.reanimate_switch.func(candidate)
	execute ":ReanimateSwitch" get(a:candidate, "action__point", "")
" 	call reanimate#load(get(a:candidate, "action__point", ""))
endfunction


let s:kind.action_table.delete = {
\	"description" : "Reanimate Delete Save",
\	"is_selectable" : 1,
\	"is_quit" : 0,
\}

function! s:kind.action_table.delete.func(candidates)
	if input("Really force delete save ? [y/n]:") == "y"
		call unite#mappings#do_action('vimfiler__delete', a:candidates, {
\			'vimfiler__current_directory' : g:reanimate_save_dir,
\			})
" 		call unite#redraw(winnr())
	else
		echo 'Canceled.'
	endif
endfunction


let s:kind.action_table.reanimate_rename = {
\	"description" : "rename save point",
\	"is_selectable" : 0
\}

function! s:kind.action_table.reanimate_rename.func(candidate)
	let to = input("Input new point name. ". get(a:candidate, "action__point", "") ." => ")
	call reanimate#rename(to)
" 	execute ":ReanimateSwitch" get(a:candidate, "action__point", "")
" 	call reanimate#load(get(a:candidate, "action__point", ""))
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo
