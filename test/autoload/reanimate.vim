function! s:owl_begin()
	let g:owl_SID = owl#filename_to_SID("vim-reanimate/autoload/reanimate.vim")
	
endfunction

function! s:owl_end()
	unlet g:owl_SID
endfunction


function! s:test_path_point()
	let tmp = g:reanimate_save_dir

	let g:reanimate_save_dir = "D:/save_point"
	let path = reanimate#point_to_path("test")
	OwlCheck path == "D:/save_point/test"

	let g:reanimate_save_dir = 'D:\save_point'
	let path = reanimate#point_to_path("test")
	OwlCheck path == "D:/save_point/test"

	let point = reanimate#path_to_point("D:/save_point/test")
	OwlCheck point == "test"


	let g:reanimate_save_dir = tmp
endfunction

function! s:test_is_disable()

	let g:reanimate_event_disables = {
	\	"_" : {
	\		"reanimate_message" : 1,
	\		"hoge_message" : 0,
	\		"foo.*" : 1,
	\		"foo_homu" : 0,
	\		'reanimate_.*': 1,
	\		'reanimate_session': 0,
	\		'reanimate_quickfix': 0,
	\	},
	\	"test" : {
	\		"reanimate_window" : 1,
	\		"reanimate_message" : 0,
	\		"foo_mami" : 0,
	\	},
	\	"test2" : {
	\		'reanimate_.*' : 1,
	\		"hoge.*" : 0,
	\		"hoge_message" : 1,
	\	},
	\	"test3" : {
	\		'reanimate_session': 1,
	\		'reanimate_quickfix': 1,
	\		'reanimate_window': 0,
	\		'reanimate_gui': 0,
	\	},
	\}

	OwlCheck  s:is_disable({"name" : "reanimate_message"}, "latest")
	OwlCheck !s:is_disable({"name" : "reanimate_message"}, "test")
	OwlCheck  s:is_disable({"name" : "reanimate_message"}, "test2")

	OwlCheck  s:is_disable({"name" : "reanimate_window"}, "latest")
	OwlCheck  s:is_disable({"name" : "reanimate_window"}, "test")
	OwlCheck  s:is_disable({"name" : "reanimate_window"}, "test2")

	OwlCheck !s:is_disable({"name" : "hoge_window"}, "latest")
	OwlCheck !s:is_disable({"name" : "hoge_window"}, "test")
	OwlCheck !s:is_disable({"name" : "hoge_window"}, "test2")

	OwlCheck !s:is_disable({"name" : "hoge_message"}, "latest")
	OwlCheck !s:is_disable({"name" : "hoge_message"}, "test")
	OwlCheck  s:is_disable({"name" : "hoge_message"}, "test2")

	OwlCheck  s:is_disable({"name" : "foo"}, "test2")
	OwlCheck  s:is_disable({"name" : "foohomu"}, "test")

	OwlCheck !s:is_disable({"name" : "foo_homu"}, "latest")
	OwlCheck !s:is_disable({"name" : "foo_mami"}, "test")

	OwlCheck  s:is_disable({"name" : "reanimate_hoge"}, "latest")
	OwlCheck !s:is_disable({"name" : "reanimate_session"}, "latest")
	OwlCheck !s:is_disable({"name" : "reanimate_quickfix"}, "latest")
	OwlCheck  s:is_disable({"name" : "reanimate_hoge"}, "test3")
	OwlCheck  s:is_disable({"name" : "reanimate_session"}, "test3")
	OwlCheck  s:is_disable({"name" : "reanimate_quickfix"}, "test3")
	OwlCheck !s:is_disable({"name" : "reanimate_window"}, "test3")
	OwlCheck !s:is_disable({"name" : "reanimate_gui"}, "test3")
endfunction



