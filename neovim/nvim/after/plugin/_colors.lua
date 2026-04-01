require("leaf").setup({
    underlineStyle = "undercurl",
    commentStyle = "italic",
    functionStyle = "NONE",
    keywordStyle = "italic",
    statementStyle = "bold",
    typeStyle = "NONE",
    variablebuiltinStyle = "italic",
    transparent = false,
    colors = {},
    overrides = {},
    theme = "light", -- default, based on vim.o.background, alternatives: "light", "dark"
    contrast = "medium", -- default, alternatives: "medium", "high"
})

require('rose-pine').setup({
	--- @usage 'auto'|'main'|'moon'|'dawn'
	variant = 'dawn',
	--- @usage 'main'|'moon'|'dawn'
	dark_variant = 'moon',
})

require('bw').setup({
	bold = true,
	italic = false,
})

function ChangeColor(color, bg)
	color = color or "base16-google-light"
	bg = bg or "light"
	vim.cmd.colorscheme(color)
	vim.cmd.set("background=" .. bg)
end

ChangeColor("bw-binary")
-- print("Colors loaded")
