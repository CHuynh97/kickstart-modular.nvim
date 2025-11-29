return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		input = {},
		gitbrowse = {},
		git = {},
	},
	keys = {
		{ "<leader>gb", function() Snacks.git.blame_line() end, desc = "[G]it [B]lame" },
		{ "<leader>go", function() Snacks.gitbrowse.open({branch = "main"}) end, desc = "[G]it [O]pen" },
	},
}
-- vim: ts=2 sts=2 sw=2 et
