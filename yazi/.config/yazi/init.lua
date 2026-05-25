require("recycle-bin"):setup()

require("bookmarks"):setup({
	last_directory = { enable = true, persist = false },
	persist = "all",
	desc_format = "parent",
	file_pick_mode = "parent",
})
