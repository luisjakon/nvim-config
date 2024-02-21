-- Plugins configurations
local function load_wilder_menu()
	local wilder = require("wilder")
	wilder.setup({ modes = { ":", "/", "?" } })
	-- Disable Python remote plugin
	wilder.set_option("use_python_remote_plugin", 0)

	wilder.set_option("pipeline", {
		wilder.branch(
			wilder.cmdline_pipeline({
				fuzzy = 1,
				fuzzy_filter = wilder.lua_fzy_filter(),
			}),
			wilder.vim_search_pipeline()
		),
	})

	wilder.set_option(
		"renderer",
		wilder.renderer_mux({
			[":"] = wilder.popupmenu_renderer({
				highlighter = wilder.lua_fzy_highlighter(),
				left = {
					" ",
					wilder.popupmenu_devicons(),
				},
				right = {
					" ",
					wilder.popupmenu_scrollbar(),
				},
			}),
			["/"] = wilder.wildmenu_renderer({
				highlighter = wilder.lua_fzy_highlighter(),
			}),
		})
	)
end

local function load_neotree()
	-- if pcall(require, "neotree") then
	--  require("neotree").setup()
	-- end
	local neotree = require("neo-tree")
	if not neotree then
		return
	end

	neotree.setup({
		popup_border_style = "rounded",
		enable_git_status = true,
		enable_diagnostics = true,
		default_component_configs = {
			-- icon = {
			--  folder_closed = signs.FolderClosed,
			--  folder_open = signs.FolderOpen,
			--  folder_empty = signs.FolderEmpty,
			-- },
			git_status = {
				symbols = {
					-- Change type
					added = "",
					deleted = "",
					modified = "",
					renamed = "➜",
					-- Status type
					untracked = "★",
					ignored = "◌",
					unstaged = "✗",
					staged = "✓",
					conflict = "",
				},
			},
		},
		window = {
			position = "left",
			width = 30,
			number = false,
			relativenumber = false,
			mapping_options = {
				-- noreamp = true,
				nowait = true,
			},
			mappings = {
				-- ["<LeftRelease>"] = "open",
			},
		},
		filesystem = {

			filtered_items = {
				visible = false, -- when true, they will just be displayed differently than normal items
				hide_dotfiles = false,
				hide_gitignored = true,
				hide_hidden = false, -- only works on Windows for hidden files/directories
				hide_by_name = {
					"node_modules",
				},
				hide_by_pattern = { -- uses glob style patterns
					"*.meta",
					"*/src/*/tsconfig.json",
				},
				always_show = { -- remains visible even if other settings would normally hide it
					".gitignored",
				},
				never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
					".DS_Store",
					"thumbs.db",
				},
				never_show_by_pattern = { -- uses glob style patterns
					".null-ls_*",
				},
			},
			follow_current_file = false, -- This will find and focus the file in the active buffer every
			-- follow_current_file = {
			-- 	enabled = true,
			-- 	leave_dirs_open = true,
			-- },
			-- time the current file is changed while the tree is open.
			group_empty_dirs = false, -- when true, empty folders will be grouped together
			hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
			-- in whatever position is specified in window.position
			-- "open_current",  -- netrw disabled, opening a directory opens within the
			-- window like netrw would, regardless of window.position
			-- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
			use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
			-- instead of relying on nvim autocmd events.
			window = {
				mappings = {
					["<bs>"] = "navigate_up",
					["."] = "set_root",
					["H"] = "toggle_hidden",
					["/"] = "fuzzy_finder",
					["D"] = "fuzzy_finder_directory",
					["f"] = "filter_on_submit",
					["<c-x>"] = "clear_filter",
					["[g"] = "prev_git_modified",
					["]g"] = "next_git_modified",
				},
			},
		},
		buffers = {
			{
				"ggandor/leap.nvim",
				name = "leap",
				config = function()
					require("leap").add_default_mappings()
				end,
			}, -- follow_current_file = true, -- This will find and focus the file in the active buffer every
			-- time the current file is changed while the tree is open.
			-- follow_current_file = false, -- This will find and focus the file in the active buffer every
			group_empty_dirs = true, -- when true, empty folders will be grouped together
			show_unloaded = true,
			window = {
				mappings = {
					["bd"] = "buffer_delete",
					["<bs>"] = "navigate_up",
					["."] = "set_root",
				},
			},
		},
		git_status = {
			window = {
				position = "float",
				mappings = {
					["A"] = "git_add_all",
					["gu"] = "git_unstage_file",
					["ga"] = "git_add_file",
					["gr"] = "git_revert_file",
					["gc"] = "git_commit",
					["gp"] = "git_push",
					["gg"] = "git_commit_and_push",
				},
			},
		},
		event_handlers = {
			--  {
			--      event = "neo_tree_buffer_enter",
			--      handler = function(arg)
			--          vim.cmd([[
			--           setlocal relativenumber
			--       ]])
			--      end,
			--  },
			--
			-- },
			{
				event = require("neo-tree.events").NEO_TREE_BUFFER_ENTER,
				handler = function()
					vim.cmd("stopinsert")
				end,
			},
		},
	})
end

local function load_telescope()
	if pcall(require, "telescope") and pcall(require, "project_nvim") then
		require("telescope").setup({
			defaults = {
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
				},
				path_display = { "smart" },
				file_sorter = require("telescope.sorters").get_fuzzy_file,
				file_ignore_patterns = { "node_modules", "^./.git/", "dist/", "build/", "target" },
				generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
				color_devicons = true,
				use_less = true,
				set_env = { ["COLORTERM"] = "truecolor" },
				file_previewer = require("telescope.previewers").vim_buffer_cat.new,
				grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
				qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
				buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
				mappings = {
					i = {
						["<Tab>"] = "move_selection_next",
						["<S-Tab>"] = "move_selection_previous",
					},
					n = {
						["<Tab>"] = "move_selection_next",
						["<S-Tab>"] = "move_selection_previous",
					},
				},
			},
			extensions = {
				file_browser = {
					-- theme = "ivy",
					-- disables netrw and use telescope-file-browser in its place
					hijack_netrw = true,
				},
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
				project = {
					base_dirs = {
						"~/Workspace/Development",
					},
					hidden_files = true, -- default: false
					theme = "dropdown",
					order_by = "asc",
					search_by = "title",
				},
			},
		})
		require("project_nvim").setup({
			detection_methods = { "pattern", "lsp" },
			patterns = { ".git", "Makefile", "package.json", "Cargo.toml", "go.mod" },
			exclude_dirs = { "~/.cargo", "node_modules" },
		})

		require("telescope").load_extension("file_browser")
		require("telescope").load_extension("ui-select")
		require("telescope").load_extension("projects")
		require("telescope").load_extension("fzf")
		require("telescope").load_extension("notify")
		require("telescope").load_extension("refactoring")
		-- require("telescope").load_extension("session-lens")
	end
end

local function load_lualine()
	if pcall(require, "lualine") then
		local hide_in_width = function()
			return vim.fn.winwidth(0) > 80
		end
		local diagnostics = {
			"diagnostics",
			sources = { "nvim_diagnostic" },
			sections = { "error", "warn" },
			symbols = { error = " ", warn = " " },
			always_visible = true,
		}
		local diff = {
			"diff",
			symbols = { added = " ", modified = " ", removed = " " },
			cond = hide_in_width,
		}
		local buffers = {
			"buffers",
			icons_enabled = false,
			icon = { align = "left" },
			symbols = { alternate_file = "" },
		}
		local spaces = function()
			return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
		end
		local function themeOpt()
			local colorscheme = vim.api.nvim_command_output("colorscheme")
			if colorscheme:match("tokyonight") then
				return "tokyonight"
			else
				return "onedark"
			end
		end
		require("lualine").setup({
			options = { theme = themeOpt(), globalstatus = true, section_separators = "", component_separators = "" },
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch" },
				lualine_c = { diagnostics, "%=", buffers },
				lualine_x = { "overseer", diff, spaces, "encoding", "filetype" },
				lualine_y = { "location" },
				lualine_z = { "progress" },
			},
		})
	end
end

local function load_indent_blankline()
	if pcall(require, "indent_blankline") then
		require("ibl").setup({
			-- show_current_context = true,
			-- show_current_context_start = false,
			-- use_treesitter = true,
			-- use_treesitter_scope = true,
			indent = {
				char = "▏",
			},
			scope = {
				show_start = false,
				show_end = false,
				highlight = { "Function", "Label" },
			},
		})
		-- vim.cmd([[
		--           highlight IndentBlanklineContextChar guifg=#6d6f79 gui=nocombine
		--       ]])
	end
end

local function load_comment()
	require("ts_context_commentstring").setup({
		enable_autocmd = false,
		languages = {
			typescript = "// %s",
		},
	})
	if pcall(require, "comment") then
		require("comment").setup({
			-- pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			-- pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		})
	end
end

local function load_autotag()
	if pcall(require, "nvim-ts-autotag") then
		require("nvim-ts-autotag").setup()
	end
end

local function load_autopairs()
	if pcall(require, "nvim-autopairs") then
		require("nvim-autopairs").setup({
			check_ts = true,
			ts_config = {
				lua = { "string", "source" },
				javascript = { "string", "template_string" },
			},
			fast_wrap = {
				map = "<M-e>",
				chars = { "{", "[", "(", '"', "'" },
				pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
				offset = 0,
				end_key = "$",
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				check_comma = true,
				highlight = "PmenuSel",
				highlight_grey = "LineNr",
			},
		})
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp_status_ok, cmp = pcall(require, "cmp")
		if not cmp_status_ok then
			return
		end
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({}))
	end
end

local function load_treesitter()
	if pcall(require, "nvim-treesitter") then
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				-- "astro",
				"bash",
				"comment",
				"c",
				"cmake",
				"cpp",
				"css",
				"gitignore",
				"html",
				"java",
				"javascript",
				"json",
				"json5",
				"graphql",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"rust",
				"svelte",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"yaml",
			},
			ignore_install = { "smali" },
			highlight = {
				enable = true, -- false will disable the whole extension
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<M-w>", -- maps in normal mode to init the node/scope selection
					node_incremental = "<M-w>", -- increment to the upper named parent
					node_decremental = "<M-C-w>", -- decrement to the previous node
					scope_incremental = "<M-e>", -- increment to the upper scope (as defined in locals.scm)
				},
			},
			indent = {
				enable = true,
			},
			playground = {
				enable = true,
				disable = {},
				updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
				persist_queries = false, -- Whether the query persists across vim sessions
				keybindings = {
					toggle_query_editor = "o",
					toggle_hl_groups = "i",
					toggle_injected_languages = "t",
					toggle_anonymous_nodes = "a",
					toggle_language_display = "I",
					focus_language = "f",
					unfocus_language = "F",
					update = "R",
					goto_node = "<cr>",
					show_help = "?",
				},
			},
			query_linter = {
				enable = true,
				use_virtual_text = true,
				lint_events = { "BufWrite", "CursorHold" },
			},
			textsubjects = {
				enable = true,
				-- prev_selection = ",", -- (Optional) keymap to select the previous selection
				keymaps = {
					["."] = "textsubjects-smart",
					[";"] = "textsubjects-container-outer",
					["i;"] = "textsubjects-container-inner",
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",

						["ac"] = "@conditional.outer",
						["ic"] = "@conditional.inner",

						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",

						["av"] = "@variable.outer",
						["iv"] = "@variable.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
				},
				-- swap = {
				--  enable = true,
				--  swap_next = {
				--      ["<Leader>sn"] = "@parameter.inner",
				--  },
				--  swap_previous = {
				--      ["<Leader>sp"] = "@parameter.inner",
				--  },
				-- },
			},
			--context_commentstring = {
			--	enable = true,
			-- With Comment.nvim. we don't need to run this on the autcmd
			--	enable_autocmd = false,
			--},
			autopairs = {
				enable = true,
			},
			rainbow = {
				enable = true,
				extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
				max_file_lines = nil, -- Do not enable for files with more than n lines, int
			},
			autotag = {
				enable = true,
			},
		})
		require("nvim-treesitter.install").update({ with_sync = true })
		-- local parser = require("nvim-treesitter.parsers").filetype_to_parsername
		-- parser.json = "json5"
		vim.treesitter.language.register("json", "json5") -- the someft filetype will use the python parser and queries.
	end
end

local function load_lsp()
	if pcall(require, "mason") and pcall(require, "mason-lspconfig") then
		local servers = {
			--"bashls",
			--"pyright",
			-- "yamlls",
			"lua_ls",
			"html",
			"cssls",
			"jsonls",
			"tailwindcss",
			"tsserver",
			"astro",
			"svelte",
			"gopls",
			"golangci_lint_ls",
			"rust_analyzer",
		}

		require("mason").setup()
		require("mason-lspconfig").setup({ ensure_installed = servers, automatic_installation = true })

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		capabilities.textDocument.completion.completionItem.resolveSupport = {
			properties = { "documentation", "detail", "additionalTextEdits" },
		}
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		local on_attach = function(client, bufnr)
			vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

			-- Mappings.
			-- See `:help vim.lsp.*` for documentation on any of the below functions
			local bufopts = { noremap = true, silent = true, buffer = bufnr }
			vim.keymap.set("n", "gcu", vim.lsp.codelens.refresh, bufopts)
			vim.keymap.set("n", "gcr", vim.lsp.codelens.run, bufopts)
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
			vim.keymap.set("n", "K", "<cmd>Lspsaga peek_definition<cr>", bufopts)
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.hover, bufopts)
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
			vim.keymap.set("n", "gl", vim.diagnostic.open_float, bufopts)
			vim.keymap.set("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", bufopts)
			vim.keymap.set("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", bufopts)

			if client.name == "tsserver" or client.name == "lua_ls" then
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end
		end

		local flags = { debounce_text_changes = 150 }

		require("mason-lspconfig").setup({
			ensure_installed = {
				"clangd",
				"cmake",
				"gopls",
				"rust_analyzer",
				"pyright",
				"lua_ls",
				"eslint",
				"tsserver",
				"jsonls",
				"emmet_ls",
				"svelte",
				"astro",
			},
			automatic_installation = true,
		})

		require("mason-lspconfig").setup_handlers({
			function(server_name)
				require("lspconfig")[server_name].setup({
					on_attach = on_attach,
					capabilities = capabilities,
					flags = flags,
					handlers = {
						["eslint/noLibrary"] = function()
							vim.notify("[lspconfig] Unable to find ESLint library.", vim.log.levels.WARN)
							return {}
						end,
					},
				})
			end,
			["lua_ls"] = function()
				local cap = capabilities
				cap.textDocument.completion.completionItem.snippetSupport = true

				require("lspconfig").lua_ls.setup({
					on_attach = on_attach,
					capabilities = cap,
					flags = flags,
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							workspace = {
								library = {
									[vim.fn.expand("$VIMRUNTIME/lua")] = true,
									[vim.fn.stdpath("config") .. "/lua"] = true,
								},
							},
						},
					},
				})
			end,
			["eslint"] = function()
				local cap = capabilities
				cap.textDocument.completion.completionItem.snippetSupport = true

				require("lspconfig").emmet_ls.setup({
					on_attach = on_attach,
					capabilities = cap,
					flags = flags,
					filetypes = {
						"astro",
						"astro-markdown",
						"html",
						"html-eex",
						"liquid",
						"markdown",
						"mdx",
						"njk",
						"nunjucks",
						"php",
						"css",
						"less",
						"postcss",
						"sass",
						"scss",
						"javascriptreact",
						"typescriptreact",
						"vue",
						"svelte",
					},
				})
			end,
			["emmet_ls"] = function()
				local cap = capabilities
				cap.textDocument.completion.completionItem.snippetSupport = true

				require("lspconfig").emmet_ls.setup({
					on_attach = on_attach,
					capabilities = cap,
					flags = flags,
					filetypes = {
						"astro",
						"astro-markdown",
						"html",
						"html-eex",
						"liquid",
						"markdown",
						"mdx",
						"njk",
						"nunjucks",
						"php",
						"css",
						"less",
						"postcss",
						"sass",
						"scss",
						"javascriptreact",
						"typescriptreact",
						"vue",
						"svelte",
					},
				})
			end,
			["tailwindcss"] = function()
				require("lspconfig").tailwindcss.setup({
					on_attach = on_attach,
					capabilities = capabilities,
					flags = flags,
					filetypes = {
						"astro",
						"astro-markdown",
						"html",
						"html-eex",
						"liquid",
						"markdown",
						"mdx",
						"njk",
						"nunjucks",
						"php",
						"css",
						"less",
						"postcss",
						"sass",
						"scss",
						"javascriptreact",
						"typescriptreact",
						"vue",
						"svelte",
					},
					settings = {
						lint = {
							unknownAtRules = "ignore",
						},
					},
				})
			end,
			["astro"] = function()
				local cap = capabilities
				cap.textDocument.completion.completionItem.snippetSupport = true

				require("lspconfig").astro.setup({
					on_attach = on_attach,
					capabilities = cap,
					flags = flags,
					filetypes = { "astro" },
					cmd = { "astro-ls", "--stdio" },
					init_options = {
						configuration = {},
					},
				})
			end,
			["svelte"] = function()
				local cap = capabilities
				cap.textDocument.completion.completionItem.snippetSupport = true

				require("lspconfig").svelte.setup({
					on_attach = on_attach,
					capabilities = cap,
					flags = flags,
					filetypes = { "svelte" },
				})
			end,
			["jsonls"] = function()
				local cap = capabilities
				cap.textDocument.completion.completionItem.snippetSupport = true

				require("lspconfig").jsonls.setup({
					on_attach = on_attach,
					capabilities = cap,
					flags = flags,
					settings = {
						json = {
							schemas = require("schemastore").json.schemas(),
							validate = { enable = true },
						},
					},
					filetypes = { "json", "jsonc", "json5" },
				})
			end,
			["tsserver"] = function()
				local cap = capabilities
				cap.textDocument.completion.completionItem.snippetSupport = true

				require("typescript").setup({
					disable_commands = false, -- prevent the plugin from creating Vim commands
					debug = false, -- enable debug logging for commands
					go_to_source_definition = {
						fallback = true, -- fall back to standard LSP definition on failure
					},
					root_dir = require("lspconfig").util.root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
					server = { -- pass options to lspconfig's setup method
						on_attach = on_attach,
						capabilities = cap,
						flags = flags,
					},
				})
			end,
			["rust_analyzer"] = function()
				local cap = capabilities
				cap.textDocument.completion.completionItem.snippetSupport = true

				require("rust-tools").setup({
					dap = {
						adapter = require("dap").adapters.codelldb,
					},
					tools = {
						runnables = { use_telescope = true },
						inlay_hints = { auto = false, show_parameter_hints = false },
						hover_actions = { auto_focus = true },
						reload_workspace_from_cargo_toml = true,
						on_initialized = function()
							vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
								pattern = { "*.rs" },
								callback = function()
									local _, _ = pcall(vim.lsp.codelens.refresh)
								end,
							})
						end,
					},
					server = {
						capabilities = cap,
						on_attach = function(client, bufnr)
							on_attach(client, bufnr)

							local rt = require("rust-tools")
							vim.keymap.set("n", "<Leader>lh", rt.hover_actions.hover_actions, { buffer = bufnr })
							vim.keymap.set(
								"n",
								"<Leader>la",
								rt.code_action_group.code_action_group,
								{ buffer = bufnr }
							)
							vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
						end,
						flags = flags,
						settings = {
							["rust-analyzer"] = {
								lens = {
									enable = true,
								},
								checkOnSave = {
									enable = true,
									command = "clippy",
								},
							},
						},
					},
				})
			end,
			["gopls"] = function()
				local go_status, go = pcall(require, "go")
				if not go_status then
					return
				end

				local cap = capabilities
				cap.textDocument.completion.completionItem.snippetSupport = true

				go.setup({
					lsp_cfg = {
						capabilities = cap,
						flags = flags,
						settings = {
							gopls = {
								hints = {
									assignVariableTypes = true,
									compositeLiteralFields = true,
									constantValues = true,
									functionTypeParameters = true,
									parameterNames = true,
									rangeVariableTypes = true,
								},
							},
						},
					},
					lsp_on_attach = on_attach,
					-- lsp_on_attach = function(client, bufnr)
					--                    require("lsp-inlayhints").on_attach(client, bufnr)
					--                    on_attach(client, bufnr)
					--                end,
					lsp_inlay_hints = { enable = false },
					-- lsp_inlay_hints = { enable = true, only_current_line = true, },
					dap_debug_gui = true, -- set to true to enable dap gui, highly recommended
					dap_debug_vt = true,
					trouble = true,
					luasnip = true,
				})
			end,
		})

		-- LSP signs
		local signs = {
			{ name = "DiagnosticSignError", text = "" },
			{ name = "DiagnosticSignWarn", text = "" },
			{ name = "DiagnosticSignHint", text = "" },
			{ name = "DiagnosticSignInfo", text = "" },
		}
		for _, sign in ipairs(signs) do
			vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
		end

		-- LSP Handlers
		local config = {
			virtual_text = false,
			signs = { active = signs },
			update_in_insert = true,
			underline = false,
			severity_sort = true,
			float = {
				focusable = true,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		}
		vim.diagnostic.config(config)
		vim.lsp.handlers["textDocument/publishDiagnostics"] =
			vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, config)
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
		vim.lsp.handlers["textDocument/signatureHelp"] =
			vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

		-- vim.cmd([[
		--       autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
		--       ]])
	end
end

local function load_cmp()
	if pcall(require, "cmp") and pcall(require, "luasnip") then
		require("luasnip.loaders.from_vscode").lazy_load()
		vim.opt.completeopt = { "menu", "menuone", "noselect" }
		local kind_icons = {
			Text = "",
			Method = "",
			Function = "",
			Constructor = "",
			Field = "",
			Variable = "",
			Class = "",
			Interface = "",
			Module = "",
			Property = "",
			Unit = "",
			Value = "",
			Enum = "",
			Keyword = "",
			Snippet = "",
			Color = "",
			File = "",
			Reference = "",
			Folder = "",
			EnumMember = "",
			Constant = "",
			Struct = "",
			Event = "",
			Operator = "",
			TypeParameter = "",
		}
		require("cmp").setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = require("cmp").mapping.preset.insert({
				["<C-k>"] = require("cmp").mapping.select_prev_item(),
				["<C-j>"] = require("cmp").mapping.select_next_item(),
				["<C-b>"] = require("cmp").mapping(require("cmp").mapping.scroll_docs(-1), { "i", "c" }),
				["<C-f>"] = require("cmp").mapping(require("cmp").mapping.scroll_docs(1), { "i", "c" }),
				["<C-Space>"] = require("cmp").mapping(require("cmp").mapping.complete(), { "i", "c" }),
				["<C-c>"] = require("cmp").mapping({
					i = require("cmp").mapping.abort(),
					c = require("cmp").mapping.close(),
				}),
				["<CR>"] = require("cmp").mapping.confirm({ select = false }),
				["<Tab>"] = require("cmp").mapping(function(fallback)
					if require("cmp").visible() then
						require("cmp").select_next_item()
					elseif require("luasnip").expandable() then
						require("luasnip").expand()
					elseif require("luasnip").expand_or_jumpable() then
						require("luasnip").expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = require("cmp").mapping(function(fallback)
					if require("cmp").visible() then
						require("cmp").select_prev_item()
					elseif require("luasnip").jumpable(-1) then
						require("luasnip").jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, vim_item)
					vim_item.kind = kind_icons[vim_item.kind]
					vim_item.menu = ({
						nvim_lsp = "LSP",
						nvim_lua = "Lua",
						luasnip = "Snip",
						buffer = "Buffer",
						path = "Path",
						emoji = "Emoji",
					})[entry.source.name]
					return vim_item
				end,
			},
			sources = {
				{ name = "nvim_lsp" },
				{ name = "nvim_lsp_signature_help" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
			},
			confirm_opts = { behavior = require("cmp").ConfirmBehavior.Replace, select = false },
			preselect = require("cmp").PreselectMode.None,
			completion = {
				completeopt = "menu,menuone,noinsert,noselect",
			},
			window = {
				completion = require("cmp").config.window.bordered(),
				documentation = require("cmp").config.window.bordered(),
			},
			experimental = { ghost_text = true },
		})
	end
end

local function load_null_ls()
	if pcall(require, "null-ls") then
		local filetypes = {
			"astro",
			"astro-markdown",
			"css",
			"html",
			"html-eex",
			"javascript",
			"javascriptreact",
			"json",
			"jsonc",
			"json5",
			"less",
			"liquid",
			"markdown",
			"markdown.mdx",
			"mdx",
			"njk",
			"nunjucks",
			"php",
			"sass",
			"scss",
			"svelte",
			"typescript",
			"typescriptreact",
			"vue",
		}

		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		local on_attach = function(client, bufnr)
			if client.supports_method("textDocument/formatting") then
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({ bufnr = bufnr })
					end,
				})
			end
		end

		require("null-ls").setup({
			debug = true,
			sources = {
				require("null-ls").builtins.formatting.stylua,
				require("null-ls").builtins.formatting.prettier.with({
					filetypes = filetypes,
					extra_filetypes = { "toml" },
					extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
				}),
				-- require("null-ls").builtins.formatting.prettierd,
				require("null-ls").builtins.formatting.markdownlint,
				require("null-ls").builtins.formatting.rustfmt.with({ extra_args = { "--edition=2021" } }),
				require("null-ls").builtins.formatting.gofmt,
				require("null-ls").builtins.formatting.golines,
				require("null-ls").builtins.formatting.goimports,
				require("null-ls").builtins.formatting.goimports_reviser,
				require("null-ls").builtins.diagnostics.revive,
				require("go.null_ls").gotest(),
				-- require("null-ls").builtins.formatting.golines.with({
				--  extra_args = {
				--      "--max-len=180",
				--      "--base-formatter=gofumpt",
				--  },
				-- }),
				-- require("null-ls").builtins.formatting.google_java_format,
				-- require("null-ls").builtins.diagnostics.flake8,
				-- require("null-ls").builtins.formatting.csharpier,
				-- require("null-ls").builtins.completion.spell,
				-- require("null-ls").builtins.formatting.eslint.with({
				--  filetypes = filetypes,
				-- }),
				require("null-ls").builtins.diagnostics.eslint.with({
					filetypes = filetypes,
				}),
				require("null-ls").builtins.code_actions.eslint.with({
					filetypes = filetypes,
				}),
				require("null-ls").builtins.code_actions.refactoring,
				require("typescript.extensions.null-ls.code-actions"),
			},
			on_attach = on_attach,
			filetypes = filetypes,
		})
	end
end

local function load_dap()
	local dap = require("dap")
	if not dap then
		return
	end

	dap.adapters.delve = {
		type = "server",
		port = "${port}",
		executable = {
			command = "dlv",
			args = { "dap", "-l", "127.0.0.1:${port}" },
		},
	}

	-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
	dap.configurations.go = {
		{
			type = "delve",
			name = "Debug",
			request = "launch",
			program = "${file}",
		},
		{
			type = "delve",
			name = "Debug test", -- configuration for debugging test files
			request = "launch",
			mode = "test",
			program = "${file}",
		},
		-- works with go.mod packages and sub packages
		{
			type = "delve",
			name = "Debug test (go.mod)",
			request = "launch",
			mode = "test",
			program = "./${relativeFileDirname}",
		},
	}

	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		executable = {
			command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
			args = { "--port", "${port}" },
		},
	}

	dap.configurations.rust = {
		{
			type = "codelldb",
			request = "launch",
			name = "Launch (Rust CodeLLDB)",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
			end,
			cwd = "${workspaceFolder}",
			terminal = "integrated",
			stopOnEntry = false,
			sourceLanguages = { "rust" },
		},
	}

	local dap_js = require("dap-vscode-js")
	if dap_js then
		dap_js.setup({
			debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
			-- debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
			adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
		})
	end

	local ft = {
		"javascript",
		"javacriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"svelte",
		"astro",
	}
	-- require("dap.ext.vscode").json_decode = require("json5").parse
	require("dap.ext.vscode").load_launchjs(nil, {
		["pwa-node"] = ft,
		["pwa-chrome"] = ft,
		["pwa-msedge"] = ft,
		["node-terminal"] = ft,
		["pwa-extensionHost"] = ft,
	})

	require("nvim-dap-virtual-text").setup()
end

local function load_dapui()
	if pcall(require, "dapui") then
		require("dapui").setup({
			expand_lines = false,
			icons = { expanded = "", collapsed = "", circular = "" },
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.33 },
						{ id = "breakpoints", size = 0.17 },
						{ id = "stacks", size = 0.25 },
						{ id = "watches", size = 0.25 },
					},
					size = 0.25,
					position = "right",
				},
				{
					elements = {
						{ id = "repl", size = 0.45 },
						{ id = "console", size = 0.55 },
					},
					size = 0.25,
					position = "bottom",
				},
			},
			floating = {
				max_height = 0.9,
				max_width = 0.5,
				border = vim.g.border_chars,
			},
		})
		-- vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

		vim.fn.sign_define("DapBreakpoint", {
			text = "●",
			texthl = "DapUIBreakpointsCurrentLine",
			linehl = "debugBreakpoint",
			numhl = "debugBreakpoint",
		})
		vim.fn.sign_define(
			"DapBreakpointCondition",
			{ text = "◆", texthl = "", linehl = "debugBreakpoint", numhl = "debugBreakpoint" }
		)
		vim.fn.sign_define(
			"DapStopped",
			{ text = "▶", texthl = "DapUIBreakpointsLine", linehl = "debugPC", numhl = "debugPC" }
		)

		require("dap").listeners.after.event_initialized["dapui_config"] = function()
			require("dapui").open()
		end
		require("dap").listeners.before.event_terminated["dapui_config"] = function()
			require("dapui").close()
		end
		require("dap").listeners.before.event_exited["dapui_config"] = function()
			require("dapui").close()
		end
	end
end

local function load_gitsigns()
	if pcall(require, "gitsigns") then
		require("gitsigns").setup({
			signs = {
				add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
				change = {
					hl = "GitSignsChange",
					text = "▎",
					numhl = "GitSignsChangeNr",
					linehl = "GitSignsChangeLn",
				},
				delete = {
					hl = "GitSignsDelete",
					text = "契",
					numhl = "GitSignsDeleteNr",
					linehl = "GitSignsDeleteLn",
				},
				topdelete = {
					hl = "GitSignsDelete",
					text = "契",
					numhl = "GitSignsDeleteNr",
					linehl = "GitSignsDeleteLn",
				},
				changedelete = {
					hl = "GitSignsChange",
					text = "▎",
					numhl = "GitSignsChangeNr",
					linehl = "GitSignsChangeLn",
				},
			},
		})
	end
end

local function load_goto_preview()
	if pcall(require, "goto-preview") then
		require("goto-preview").setup({
			width = 120, -- Width of the floating window
			height = 15, -- Height of the floating window
			border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }, -- Border characters of the floating window
			default_mappings = true,
			debug = false, -- Print debug information
			opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
			resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
			post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
			references = { -- Configure the telescope UI for slowing the references cycling window.
				telescope = require("telescope.themes").get_dropdown({ hide_preview = false }),
			},
			-- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
			focus_on_open = true, -- Focus the floating window when opening it.
			dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
			force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
			bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
			stack_floating_preview_windows = true, -- Whether to nest floating windows
			preview_window_title = { enable = true, position = "left" }, -- Whether
		})
	end
end

local function load_whichkey()
	if pcall(require, "which-key") then
		vim.o.timeout = true
		vim.o.timeoutlen = 300

		local wk = require("which-key")
		wk.setup({
			show_help = false,
			triggers = "auto",
			plugins = { spelling = true },
			key_labels = { ["<leader>"] = "SPC" },
		})

		-- local leader = {
		--  f = {
		--      name = "+file",
		--      b = { "<cmd>Telescope buffers<cr>", "Buffers" },
		--      f = { "<cmd>Telescope find_files<cr>", "Find File" },
		--      o = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
		--      n = { "<cmd>enew<cr>", "New File" },
		--      g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
		--      c = { "<cmd>Telescope commands<cr>", "Commands" },
		--      r = { "<cmd>Telescope file_browser<cr>", "Browser" },
		--      w = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Current Buffer" },
		--      t = { "<cmd>Neotree toggle<cr>", "File Explorer" },
		--  },
		--  n = {
		--      name = "+filetree",
		--      n = { "<cmd>Neotree toggle<cr>", "File Explorer" },
		--      r = { "<cmd>Neotree reveal<cr>", "Reveal" },
		--  },
		--  l = {
		--      name = "+lsp",
		--      i = { "<cmd>Mason<cr>", "Manage Servers" },
		--      -- l = { "<cmd>MasonLog<cr>", "See logs" }
		--  },
		--  s = {
		--      name = "+search",
		--      g = { "<cmd>Telescope live_grep<cr>", "Grep" },
		--      b = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Buffer" },
		--      s = {
		--          function()
		--              require("telescope.builtin").lsp_document_symbols({
		--                  symbols = {
		--                      "Class",
		--                      "Function",
		--                      "Method",
		--                      "Constructor",
		--                      "Interface",
		--                      "Module",
		--                      "Struct",
		--                      "Trait",
		--                      "Field",
		--                      "Property",
		--                  },
		--              })
		--          end,
		--          "Goto Symbol",
		--      },
		--      h = { "<cmd>Telescope command_history<cr>", "Command History" },
		--      m = { "<cmd>Telescope marks<cr>", "Jump to Mark" },
		--      r = { "<cmd>lua require('spectre').open()<cr>", "Replace (Spectre)" },
		--  },
		-- }
		--
		-- wk.register(leader, { prefix = "<leader>" })

		local opts = {
			mode = "n", -- NORMAL mode
			-- prefix: use "<leader>f" for example for mapping everything related to finding files
			-- the prefix is prepended to every mapping part of `mappings`
			prefix = "<space>",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = false, -- use `nowait` when creating keymaps
		}

		require("which-key").register({
			["\\"] = { "<cmd>ToggleTerm<CR>", "Toggle Term" },
			["/"] = { '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', "Comment" },
			["c"] = {
				name = "Code",
				a = { "<cmd>Lspsaga code_action<cr>", "Lsp Code Actions" },
				f = { "<cmd>Lspsaga lsp_finder<cr>", "Lsp Find" },
				d = {
					name = "Diagnostics",
					b = { "<cmd>Lspsaga show_buffer_diagnostics<CR>", "Buffer Diagnostics" },
					c = { "<cmd>Lspsaga show_cursor_diagnostics<CR>", "Cursor Diagnostics" },
					l = { "<cmd>Lspsaga show_line_diagnostics<CR>", "Line Diagnostics" },
					w = { "<cmd>Lspsaga show_worskspace_diagnostics<CR>", "Workspace Diagnostics" },
				},
				g = { "<cmd>Lspsaga goto_definition<cr>", "Goto Definition" },
				h = { "<cmd>Lspsaga hover_doc<cr>", "Lsp Hover Doc" },
				p = { "<cmd>Lspsaga peek_definition<cr>", "Peek Definition" },
				o = { "<cmd>Lspsaga outline<cr>", "Code Outline" },
				t = {
					name = "Test",
					a = { "<cmd>lua require('neotest').run.attach()<cr>", "Attach" },
					f = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "Run File" },
					F = {
						"<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>",
						"Debug File",
					},
					l = { "<cmd>lua require('neotest').run.run_last()<cr>", "Run Last" },
					L = { "<cmd>lua require('neotest').run.run_last({ strategy = 'dap' })<cr>", "Debug Last" },
					n = { "<cmd>lua require('neotest').run.run()<cr>", "Run Nearest" },
					N = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", "Debug Nearest" },
					o = { "<cmd>lua require('neotest').output.open({ enter = true })<cr>", "Output" },
					S = { "<cmd>lua require('neotest').run.stop()<cr>", "Stop" },
					s = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Summary" },
					p = { "<Plug>PlenaryTestFile", "PlenaryTestFile" },
					v = { "<cmd>TestVisit<cr>", "Visit" },
					x = { "<cmd>TestSuite<cr>", "Suite" },
				},
				O = {
					name = "Overseer",
					C = { "<cmd>OverseerClose<cr>", "OverseerClose" },
					a = { "<cmd>OverseerTaskAction<cr>", "OverseerTaskAction" },
					b = { "<cmd>OverseerBuild<cr>", "OverseerBuild" },
					c = { "<cmd>OverseerRunCmd<cr>", "OverseerRunCmd" },
					d = { "<cmd>OverseerDeleteBundle<cr>", "OverseerDeleteBundle" },
					l = { "<cmd>OverseerLoadBundle<cr>", "OverseerLoadBundle" },
					o = { "<cmd>OverseerOpen!<cr>", "OverseerOpen" },
					q = { "<cmd>OverseerQuickAction<cr>", "OverseerQuickAction" },
					r = { "<cmd>OverseerRun<cr>", "OverseerRun" },
					s = { "<cmd>OverseerSaveBundle<cr>", "OverseerSaveBundle" },
					t = { "<cmd>OverseerToggle!<cr>", "OverseerToggle" },
				},
			},
			["d"] = {
				name = "Debug",
				b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Breakpoint" },
				c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
				i = { "<cmd>lua require'dap'.step_into()<cr>", "Into" },
				o = { "<cmd>lua require'dap'.step_over()<cr>", "Over" },
				O = { "<cmd>lua require'dap'.step_out()<cr>", "Out" },
				r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Repl" },
				l = { "<cmd>lua require'dap'.run_last()<cr>", "Last" },
				u = { "<cmd>lua require'dapui'.toggle()<cr>", "UI" },
				x = { "<cmd>lua require'dap'.terminate()<cr>", "Exit" },
				t = { "<cmd>TroubleToggle<cr>", "Toggle Trouble  Diagnostics" },
			},
			["f"] = {
				name = "Find",
				b = { "<cmd>Telescope buffers<cr>", "Buffers" },
				f = { "<cmd>Telescope find_files<cr>", "Files" },
				n = { "<cmd>enew<cr>", "New File" },
				e = { "<cmd>Telescope file_browser<cr>", "Browser" },
				t = { "<cmd>Neotree toggle<cr>", "File Explorer" },
			},
			["g"] = {
				name = "Git",
				g = { "<cmd>LazyGit<cr>", "Lazygit" },
				j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
				k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
				-- l = { "<cmd>GitBlameToggle<cr>", "Blame" },
				p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
				r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
				R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
				s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
				u = {
					"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
					"Undo Stage Hunk",
				},
				o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
				b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
				c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
				d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Diff" },
			},
			["l"] = {
				name = "LSP",
				a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
				-- c = { "<cmd>lua require('copilot.suggestion').toggle_auto_trigger()<cr>", "Get Capabilities" },
				f = { "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", "Format Document" },
				i = { "<cmd>LspInfo<cr>", "Info" },
				I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
				j = {
					"<cmd>lua vim.diagnostic.goto_next({buffer=0})<CR>",
					"Next Diagnostic",
				},
				k = {
					"<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>",
					"Prev Diagnostic",
				},
				l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
				o = { "<cmd>SymbolsOutline<cr>", "Outline" },
				q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Quickfix" },
				r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
				R = { "<cmd>TroubleToggle lsp_references<cr>", "References" },
				s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
				S = {
					"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
					"Workspace Symbols",
				},
				u = { "<cmd>LuaSnipUnlinkCurrent<cr>", "Unlink Snippet" },
				t = {
					name = "Toggle",
					f = { "<cmd>LspToggleAutoFormat<cr>", "Toggle Autoformat" },
					h = { "<cmd>lua require('lsp-inlayhints').toggle()<cr>", "Toggle Hints" },
					i = { "<cmd>IlluminationToggle<cr>", "Toggle Doc HL" },
					v = { "<cmd>lua require('lsp_lines').toggle()<cr>", "Toggle Virtual Text" },
				},
				w = {
					"<cmd>Telescope lsp_workspace_diagnostics<cr>",
					"Workspace Diagnostics",
				},
			},
			["p"] = {
				name = "Project",
				p = { '<cmd>lua require("telescope").extensions.project.project{}<CR>', "Workspaces" },
				-- s = { '<cmd>Telescope repo list<cr>', 'Search' },
			},
			["q"] = { "<cmd>bd<CR> ", "Close" },
			["Q"] = { "<cmd>qa<cr>", "Quit" },
			["s"] = {
				name = "Search",
				b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
				c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
				f = { "<cmd>Telescope live_grep<cr>", "Find Text" },
				F = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Search Buffer" },
				s = { "<cmd>Telescope grep_string<cr>", "Find String" },
				h = { "<cmd>Telescope help_tags<cr>", "Help" },
				H = { "<cmd>Telescope highlights<cr>", "Highlights" },
				i = { "<cmd>lua require('telescope').extensions.media_files.media_files()<cr>", "Media" },
				l = { "<cmd>Telescope resume<cr>", "Last Search" },
				M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
				r = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
				R = { "<cmd>Telescope registers<cr>", "Registers" },
				k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
				C = { "<cmd>Telescope commands<cr>", "Commands" },
			},
			["t"] = {
				name = "Trouble Diagnostics",
				t = { "<cmd>TroubleToggle<cr>", "trouble" },
				w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
				d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
				q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
				l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
				r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
			},
			["v"] = {
				name = "VSCode",
				a = { '<cmd>lua require("telescope").extensions.vstask.tasks()<CR>', "Run Tasks" },
				i = { '<cmd>lua require("telescope").extensions.vstask.inputs()<CR>', "Tasks Inputs" },
				h = { '<cmd>lua require("telescope").extensions.vstask.history()<CR>', "Task History" },
				l = { '<cmd>lua require("telescope").extensions.vstask.launch()<CR>', "Launch Tasks" },
			},
			["w"] = { "<cmd>update!<CR>", "Save" },
			["z"] = { "<cmd>TZFocus<CR>", "Zen Mode" },
		}, opts)
	end
end

local M = {
	load_wilder_menu = load_wilder_menu,
	load_neotree = load_neotree,
	load_telescope = load_telescope,
	load_lualine = load_lualine,
	load_indent_blankline = load_indent_blankline,
	load_comment = load_comment,
	load_autotag = load_autotag,
	load_autopairs = load_autopairs,
	load_treesitter = load_treesitter,
	load_lsp = load_lsp,
	load_cmp = load_cmp,
	load_null_ls = load_null_ls,
	load_dap = load_dap,
	load_dapui = load_dapui,
	load_gitsigns = load_gitsigns,
	load_goto_preview = load_goto_preview,
	load_whichkey = load_whichkey,
}

return M
