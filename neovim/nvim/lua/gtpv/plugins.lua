-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.2',
		-- or                            , branch = '0.1.x',
		dependencies = {
			{'nvim-lua/plenary.nvim'},
		}
	},
	'nvim-treesitter/nvim-treesitter',
	'nvim-treesitter/playground',
	'theprimeagen/harpoon',
	'mbbill/undotree',
	{
		"mcchrish/zenbones.nvim",
		dependencies = "rktjmp/lush.nvim"
	},

	'RRethy/nvim-base16',

	'daschw/leaf.nvim',
	'tk4n9/bw.nvim',
	'nyoom-engineering/oxocarbon.nvim',
	'savq/melange-nvim',
	'rose-pine/neovim',


	'ojroques/nvim-hardline',

	'github/copilot.vim',

        {
                'neovim/nvim-lspconfig',
                dependencies = {
                        -- LSP Support
                        'williamboman/mason.nvim',
                        'williamboman/mason-lspconfig.nvim',

                        -- Autocompletion
                        'hrsh7th/nvim-cmp',
                        'hrsh7th/cmp-nvim-lsp',
                        'saadparwaiz1/cmp_luasnip',
                        'hrsh7th/cmp-buffer',
                        'hrsh7th/cmp-path',

                        -- Snippets
                        'L3MON4D3/LuaSnip',
                        'rafamadriz/friendly-snippets',
                }
        },
	{
		"vhyrro/luarocks.nvim",
		priority = 1000,
		config = true,
	},
	{ 'projekt0n/github-nvim-theme', name = 'github-theme' },
	{
		"robitx/gp.nvim",
		config = function()
			local conf = {
				-- For customization, refer to Install > Configuration in the Documentation/Readme
				openai_api_key = os.getenv("OPENAI_API_KEY"),

				providers = {
					openai = {
						disable = true,
						endpoint = "https://api.openai.com/v1/chat/completions",
					},
					copilot = {
						disable = false,
						endpoint = "https://api.githubcopilot.com/chat/completions",
						secret = {
							"zsh",
							"-c",
							"cat ~/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'",
						},
					},
					ollama = {
						disable = true,
						endpoint = "http://localhost:11434/v1/chat/completions",
						secret = "dummy_secret",
					},
				}
			}
			require("gp").setup(conf)

			-- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
			-- Saved on the after/plugins/_gp.lua file
		end,
	},
	{
		"tadmccorkle/markdown.nvim",
		ft = "markdown", -- or 'event = "VeryLazy"'
		opts = {
			-- configuration here or empty for defaults
		},
	},
	{
		'GTPV/render-whitespace.nvim',
		config = function()
			require('render-whitespace').setup({
				chars = {
					space = '·',
					tab = '↦',
					newline = '↲',
					trail = '•',
				},
				modes = {
					normal = false,
					visual = true,
					insert = false,
				},
				enabled = true,
				highlight_group = 'Whitespace',
				-- colors = {
					-- fg = '#666666',        -- Subtle gray for whitespace
					-- visual_fg = '#ffd700', -- Gold when in visual selection
				-- },
			})

			-- Add keymaps using the recommended command style
			vim.keymap.set('n', '<leader>tw', '<cmd>RenderWhitespaceToggle<cr>', 
			{ desc = 'Toggle whitespace rendering' })

			vim.keymap.set('n', '<leader>tn', '<cmd>RenderWhitespaceToggleNormal<cr>', 
			{ desc = 'Toggle whitespace in normal mode' })

			vim.keymap.set('n', '<leader>tv', '<cmd>RenderWhitespaceToggleVisual<cr>', 
			{ desc = 'Toggle whitespace in visual mode' })

			vim.keymap.set('n', '<leader>ti', '<cmd>RenderWhitespaceToggleInsert<cr>', 
			{ desc = 'Toggle whitespace in insert mode' })

			-- Color management keymap
			vim.keymap.set('n', '<leader>wc', '<cmd>RenderWhitespaceSetColors fg=#ff6b6b visual_fg=#4ecdc4<cr>', 
			{ desc = 'Set custom whitespace colors' })
		end,
	},
}

local opts = {
	rocks = {
		enabled = false,
	},
}

require('lazy').setup(plugins, opts)
