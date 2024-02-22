require("user.keymaps")
require("user.options")

-- Autocommands
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
	callback = function()
		vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]])
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "Trouble" },
	callback = function()
		vim.opt_local.wrap = true
	end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
	end,
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
	callback = function()
		vim.cmd("hi link illuminatedWord LspReferenceText")
	end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	callback = function()
		local line_count = vim.api.nvim_buf_line_count(0)
		if line_count >= 5000 then
			vim.cmd("IlluminatePauseBuf")
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*.json" },
	callback = function()
		vim.cmd("setlocal filetype=jsonc")
	end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*.vert", "*.frag" },
	callback = function()
		vim.cmd("setlocal filetype=glsl")
	end,
})

vim.cmd("autocmd BufNewFile,BufRead *.md,*.mdx,*.markdown :set filetype=markdown")

-- vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
--  pattern = { "*.java", "*.go", "*.rs" },
--  callback = function()
--      vim.lsp.codelens.refresh()
--  end,
-- })

local plugins = require("user.plugins")

-- Plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

if pcall(require, "lazy") then
	require("lazy").setup({
		{
			"folke/tokyonight.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				vim.cmd.colorscheme("tokyonight-night")
				vim.cmd([[
                hi WinSeparator guifg=#3b4261
                ]])
				-- vim.cmd.colorscheme("tokyonight-day")
				require("tokyonight").setup({
					style = "night",
					-- day_brightness = 0.95,
					-- on_colors = function(colors)
					-- 	-- colors.bg = "#0e0e0e"
					-- 	colors.bg_dark = "#1d202f"
					-- 	-- colors.bg = "#1d202f"
					-- 	colors.bg = "#171826"
					-- end,
					on_highlights = function(hl, c)
						hl.WinSeparator = { fg = c.fg_gutter, bg = c.fg_gutter }
					end,
				})
			end,
		},
		{
			"ggandor/leap.nvim",
			name = "leap",
			config = function()
				require("leap").add_default_mappings()
			end,
		},
		{
			"gelguy/wilder.nvim",
			dependencies = { "romgrk/fzy-lua-native" },
			config = function()
				plugins.load_wilder_menu({})
			end,
		},
		{
			"goolord/alpha-nvim",
			dependencies = { "kyazdani42/nvim-web-devicons" },
			config = function()
				vim.cmd("let g:indentLine_fileTypeExclude = ['alpha']")
				vim.cmd("autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2")
				require("alpha").setup(require("alpha.themes.dashboard").config)
			end,
		},
		{
			"nvim-zh/colorful-winsep.nvim",
			config = function()
				require("colorful-winsep").setup({
					highlight = {
						-- bg = "#16161E",
						fg = "#626780",
					},
					symbols = { "─", "│", "┌", "┐", "└", "┘" },
				})
			end,
		},
		{
			"Pocco81/true-zen.nvim",
			config = function()
				require("true-zen").setup({
					focus = {
						callbacks = {
							open_pos = function()
								-- folding
								vim.o.foldlevel = 99
								vim.o.foldlevelstart = 99
								vim.o.foldcolumn = "1"
								vim.o.foldenable = true
								vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
							end,
						},
					},
				})
			end,
		},
		-- {
		--  "projekt0n/github-nvim-theme",
		--  tag = "v0.0.7",
		--  config = function()
		--      require("github-theme").setup({
		--          -- dark_sidebar = true,
		--          hide_inactive_statusline = true,
		--          sidebars = { "qf", "vista_kind", "terminal", "NeoTree" },
		--          colors = {
		--              -- bg = "#ffffff",
		--              -- bg2 = "#ffffff",
		--              -- white = "#ffffff"
		--              bg_highlight = "#f5f5f5",
		--              -- bg_visual_selection = "#b6e3ff",
		--          },
		--          overrides = function(c)
		--              return {
		--                  -- DapUi
		--                  DapUINormal = { link = "Normal" },
		--                  DapUIVariable = { link = "Normal" },
		--                  DapUIScope = { fg = c.blue },
		--                  DapUIType = { fg = "#D484FF" },
		--                  DapUIValue = { link = "Normal" },
		--                  DapUIModifiedValue = { fg = c.blue },
		--                  DapUIDecoration = { fg = c.blue },
		--                  DapUIThread = { fg = c.green, style = "bold" },
		--                  DapUIStoppedThread = { fg = c.blue },
		--                  DapUIFrameName = { link = "Normal" },
		--                  DapUISource = { fg = "#D484FF" },
		--                  DapUILineNumber = { fg = c.blue },
		--                  DapUIFloatNormal = { link = "NormalFloat" },
		--                  DapUIFloatBorder = { fg = c.blue },
		--                  DapUIWatchesEmpty = { fg = "#F70067" },
		--                  DapUIWatchesValue = { fg = c.green, style = "bold" },
		--                  DapUIWatchesError = { fg = "#F70067" },
		--                  DapUIBreakpointsPath = { fg = c.blue },
		--                  DapUIBreakpointsInfo = { fg = c.green, style = "bold" },
		--                  DapUIBreakpointsCurrentLine = { fg = c.green, style = "bold" },
		--                  DapUIBreakpointsLine = { link = "DapUILineNumber" },
		--                  DapUIBreakpointsDisabledLine = { fg = "#424242" },
		--                  DapUICurrentFrameName = { link = "DapUIBreakpointsCurrentLine" },
		--                  DapUIStepOver = { fg = c.blue },
		--                  DapUIStepInto = { fg = c.blue },
		--                  DapUIStepBack = { fg = c.blue },
		--                  DapUIStepOut = { fg = c.blue },
		--                  DapUIStop = { fg = "#F70067" },
		--                  DapUIPlayPause = { fg = c.green, style = "bold" },
		--                  DapUIRestart = { fg = c.green, style = "bold" },
		--                  DapUIUnavailable = { fg = "#424242" },
		--                  DapUIWinSelect = { fg = c.blue },
		--                  DapUIEndofBuffer = { link = "EndofBuffer" },
		--              }
		--          end,
		--      })
		--      vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Visual" })
		--      vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Visual" })
		--      vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })
		--      -- vim.cmd.colorscheme("github_light")
		--  end,
		-- },
		{
			"akinsho/bufferline.nvim",
			config = function()
				require("bufferline").setup({
					options = {
						separator_style = "thin",
						offsets = {
							{
								filetype = "neo-tree",
								text = "File Explorer",
								text_align = "center",
								separator = true,
							},
						},
						themable = true,
						close_icon = "",
					},
				})
			end,
		},
		-- {
		--  "utilyre/barbecue.nvim",
		--  dependencies = {
		--      "SmiteshP/nvim-navic",
		--      "kyazdani42/nvim-web-devicons", -- optional dependency
		--  },
		--  after = "nvim-web-devicons", -- keep this if you're using NvChad
		--  config = function()
		--      require("barbecue").setup()
		--  end,
		-- },
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "kyazdani42/nvim-web-devicons" },
			config = function()
				plugins.load_lualine()
			end,
		},
		{
			"gpanders/editorconfig.nvim",
			event = { "BufRead .editorconfig" },
		},
		{
			"lukas-reineke/indent-blankline.nvim",
			event = "BufReadPre",
			main = "ibl",
			config = function()
				plugins.load_indent_blankline()
			end,
		},
		{
			"dstein64/nvim-scrollview",
			config = function()
				require("scrollview").setup({
					current_only = true,
					winblend = 50,
				})
			end,
		},
		{
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v2.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
				"MunifTanjim/nui.nvim",
			},
			config = function()
				plugins.load_neotree()
			end,
		},
		{
			"nvim-telescope/telescope.nvim",
			event = "BufEnter",
			dependencies = {
				"nvim-lua/plenary.nvim",
				-- "ahmedkhalf/project.nvim",
				{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
				{ "nvim-telescope/telescope-file-browser.nvim" },
				{ "nvim-telescope/telescope-project.nvim" },
				{ "nvim-telescope/telescope-ui-select.nvim" },
				{
					"Shatur/neovim-session-manager",
					config = function()
						require("session_manager").setup({
							autoload_mode = require("session_manager.config").AutoloadMode.CurrentDir, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
							autosave_only_in_session = true,
						})
					end,
				},
				-- {
				-- 	"rmagatti/session-lens",
				-- 	dependencies = {
				-- 		{
				-- 			"rmagatti/auto-session",
				-- 			config = function()
				-- 				local close_floating_windows = function()
				-- 					local api = vim.api
				-- 					for _, win in ipairs(api.nvim_list_wins()) do
				-- 						local config = api.nvim_win_get_config(win)
				-- 						if config.relative ~= "" then
				-- 							vim.api.nvim_win_close(win, false)
				-- 						end
				-- 					end
				-- 				end
				-- 				require("auto-session").setup({
				-- 					log_level = "error",
				-- 					auto_session_suppress_dirs = { "~/", "/" },
				-- 					auto_session_allowed_dirs = { "~/Workspace/Development" },
				-- 					auto_session_use_git_branch = true,
				-- 					pre_save_cmds = {
				-- 						"Neotree close",
				-- 						"cclose",
				-- 						"lua vim.notify.dismiss()",
				-- 						close_floating_windows,
				-- 					},
				-- 				})
				-- 			end,
				-- 		},
				-- 	},
				-- 	config = function()
				-- 		require("session-lens").setup({
				-- 			-- path_display = { "shorten" },
				-- 			-- theme = 'ivy', -- default is dropdown
				-- 			-- theme_conf = { border = false },
				-- 			-- previewer = true,
				-- 			prompt_title = "SAVED SESSIONS",
				-- 		})
				-- 	end,
				-- },
			},
			config = function()
				plugins.load_telescope()
			end,
		},
		{
			"windwp/nvim-ts-autotag",
			event = "InsertEnter",
			config = function()
				plugins.load_autotag()
			end,
		},
		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = function()
				plugins.load_autopairs()
			end,
		},
		{
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		{
			"numToStr/Comment.nvim",
			event = "BufRead",
			config = function()
				plugins.load_comment()
			end,
		},
		{
			"/nvim-colortils/colortils.nvim",
			config = function()
				require("colortils").setup({})
			end,
		},
		{ "RRethy/vim-illuminate", event = "VeryLazy" },
		{
			"NvChad/nvim-colorizer.lua",
			config = function()
				if pcall(require, "colorizer") then
					require("colorizer").setup({})
				end
			end,
		},
		{
			"lewis6991/gitsigns.nvim",
			event = "BufReadPre",
			config = function()
				plugins.load_gitsigns()
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter",
			event = "BufReadPost",
			dependencies = {
				"nvim-treesitter/playground",
				"nvim-treesitter/nvim-treesitter-textobjects",
				"p00f/nvim-ts-rainbow",
				"windwp/nvim-ts-autotag",
			},
			config = function()
				plugins.load_treesitter()
			end,
		},
		-- https://github.com/nvim-treesitter/nvim-treesitter-context
		{
			"nvim-treesitter/nvim-treesitter-context",
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
			},
			config = function()
				require("treesitter-context").setup({
					enable = true,
					max_lines = 2,
				})
			end,
		},
		{
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			dependencies = {
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-nvim-lsp-signature-help",
				"saadparwaiz1/cmp_luasnip",
			},
			config = function()
				plugins.load_cmp()
			end,
		},
		{
			"L3MON4D3/LuaSnip",
			event = "InsertEnter",
			dependencies = { "rafamadriz/friendly-snippets" },
		},
		{
			"ThePrimeagen/refactoring.nvim",
			dependencies = {
				{ "nvim-lua/plenary.nvim" },
				{ "nvim-treesitter/nvim-treesitter" },
			},
		},
		{
			"neovim/nvim-lspconfig",
			lazy = true,
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"williamboman/mason-lspconfig.nvim",
				"b0o/schemastore.nvim",
				"jose-elias-alvarez/typescript.nvim",
				{
					"simrat39/rust-tools.nvim",
					dependencies = {
						{
							"saecki/crates.nvim",
							tag = "v0.3.0",
							event = { "BufRead Cargo.toml" },
							dependencies = { "nvim-lua/plenary.nvim" },
							config = function()
								require("crates").setup()
							end,
						},
					},
				},
				{
					"ray-x/go.nvim",
					dependencies = {
						"ray-x/guihua.lua",
					},
					config = function()
						require("go").setup({
							lsp_document_formatting = false,
						})
					end,
					ft = { "go", "gomod" },
					build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
				},
				{
					"mxsdev/nvim-dap-vscode-js",
					dependencies = {
						{
							"microsoft/vscode-js-debug",
							build = "pnpm install && pnpm run compile",
						},
						{
							"EthanJWright/vs-tasks.nvim",
							dependencies = {
								"nvim-lua/popup.nvim",
								"nvim-lua/plenary.nvim",
								"nvim-telescope/telescope.nvim",
							},
							config = function()
								require("vstask").setup()
							end,
						},
						{
							"vuki656/package-info.nvim",
							dependencies = "MunifTanjim/nui.nvim",
							config = function()
								require("package-info").setup({
									package_manager = "pnpm",
								})
							end,
						},
					},
				},
				{
					"lvimuser/lsp-inlayhints.nvim",
					config = function()
						require("lsp-inlayhints").setup()
						--                    vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
						--  vim.api.nvim_create_autocmd("LspAttach", {
						--      group = "LspAttach_inlayhints",
						--      callback = function(args)
						--          if not (args.data and args.data.client_id) then
						--              return
						--          end
						--
						--          local bufnr = args.buf
						--          local client = vim.lsp.get_client_by_id(args.data.client_id)
						--          require("lsp-inlayhints").on_attach(client, bufnr)
						--      end,
						--  })
					end,
				},
			},
		},
		{
			"glepnir/lspsaga.nvim",
			event = "BufRead",
			config = function()
				require("lspsaga").setup({
					ui = {
						code_action = "",
					},
					lightbulb = {
						enable = true,
						enable_in_insert = true,
						sign = false,
						sign_priority = 40,
						virtual_text = true,
					},
				})
			end,
			dependencies = {
				{ "kyazdani42/nvim-web-devicons" },
				--Please make sure you install markdown and markdown_inline parser
				{ "nvim-treesitter/nvim-treesitter" },
			},
		},
		{
			"rmagatti/goto-preview",
			config = function()
				plugins.load_goto_preview()
			end,
		},
		{
			"williamboman/mason.nvim",
			dependencies = { "williamboman/mason-lspconfig.nvim" },
			config = function()
				plugins.load_lsp()
			end,
		},
		{
			"jose-elias-alvarez/null-ls.nvim",
			event = "BufReadPre",
			config = function()
				plugins.load_null_ls()
			end,
		},
		{
			"mfussenegger/nvim-dap",
			dependencies = {
				"theHamsta/nvim-dap-virtual-text",
				{ "Joakker/lua-json5", build = "./install.sh" },
			},
			config = function()
				plugins.load_dap()
			end,
		},
		{
			"rcarriga/nvim-dap-ui",
			event = "VeryLazy",
			config = function()
				plugins.load_dapui()
			end,
		},
		{
			"nvim-neotest/neotest",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-treesitter/nvim-treesitter",
				"antoinemadec/FixCursorHold.nvim",
				"nvim-neotest/neotest-plenary",
				"nvim-neotest/neotest-python",
				"haydenmeade/neotest-jest",
				"nvim-neotest/neotest-go",
				"rouge8/neotest-rust",
				"nvim-neotest/neotest-vim-test",
			},
			config = function()
				-- get neotest namespace (api call creates or returns namespace)
				local neotest_ns = vim.api.nvim_create_namespace("neotest")
				vim.diagnostic.config({
					virtual_text = {
						format = function(diagnostic)
							local message =
								diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
							return message
						end,
					},
				}, neotest_ns)
				require("neotest").setup({
					consumers = {
						overseer = require("neotest.consumers.overseer"),
					},
					overseer = {
						enabled = true,
						-- When this is true (the default), it will replace all neotest.run.* commands
						force_default = false,
					},
					adapters = {
						require("neotest-rust"),
						require("neotest-go"),
					},
				})
			end,
		},
		{
			"stevearc/overseer.nvim",
			config = function()
				require("overseer").setup({
					strategy = "toggleterm",
					use_shell = true,
				})
			end,
		},
		{ "jamestthompson3/nvim-remote-containers" },
		{
			"folke/trouble.nvim",
			cmd = { "TroubleToggle", "Trouble" },
			opts = {
				auto_open = false,
				use_diagnostic_signs = true,
			},
		},
		{
			"folke/which-key.nvim",
			config = function()
				plugins.load_whichkey()
			end,
		},
		{
			"karb94/neoscroll.nvim",
			keys = { "<C-u>", "<C-d>", "gg", "G" },
			config = function()
				require("neoscroll").setup()
			end,
		},
		{
			"akinsho/toggleterm.nvim",
			event = "VeryLazy",
			config = function()
				require("toggleterm").setup()
			end,
		},
		{
			"mg979/vim-visual-multi",
			branch = "master",
		},
		{
			"rcarriga/nvim-notify",
			config = function()
				vim.notify = require("notify")
			end,
		},
		{
			"gen740/SmoothCursor.nvim",
			config = function()
				require("smoothcursor").setup({ fancy = { enable = true } })
			end,
		},
		{
			"kevinhwang91/nvim-ufo", -- better folding for neovim
			dependencies = {
				"kevinhwang91/promise-async",
				{
					"luukvbaal/statuscol.nvim",
					event = "VeryLazy",
					config = function()
						local builtin = require("statuscol.builtin")
						require("statuscol").setup({
							relculright = true,
							segments = {
								{ text = { "%s" }, click = "v:lua.ScSa" },
								{ text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
								{
									text = { " ", builtin.foldfunc, " " },
									condition = { true, builtin.not_empty },
									click = "v:lua.ScFa",
								},
							},
						})
					end,
				},
			},
			event = "BufReadPost",
			keys = {
				{
					"[z",
					function()
						require("ufo").goPreviousClosedFold()
					end,
					desc = "Ufo: go to previous closed fold",
				},
				{
					"]z",
					function()
						require("ufo").goNextClosedFold()
					end,
					desc = "Ufo: go to next closed fold",
				},
				{
					"zR",
					function()
						require("ufo").openAllFolds()
					end,
					desc = "Ufo: open all folds",
				},
				{
					"zM",
					function()
						require("ufo").closeAllFolds()
					end,
					desc = "Ufo: close all folds",
				},
				{
					"zr",
					function()
						require("ufo").openFoldsExceptKinds()
					end,
					desc = "Ufo: open folds except kinds",
				},
				{
					"zm",
					function()
						require("ufo").closeFoldsWith()
					end,
					desc = "Ufo: close folds",
				},
				{
					"zp",
					function()
						local winid = require("ufo").peekFoldedLinesUnderCursor()
						if not winid then
							vim.lsp.buf.hover()
						end
					end,
					desc = "Ufo: preview",
				},
			},
			opts = function()
				require("ufo").setup({
					-- fold_virt_text_handler = handler,
					provider_selector = function(bufnr, filetype, buftype)
						return { "treesitter", "indent" }
					end,
					-- preview = {
					--  win_config = {
					--      winhighlight = "Normal:Folded",
					--      winblend = 0,
					--  },
					--  mappings = {
					--      scrollU = "<C-u>",
					--      scrollD = "<C-d>",
					--  },
					-- },
				})
			end,
		},
	})
end
