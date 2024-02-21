-- Bindingsa
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

vim.keymap.set("", "<Space>", "<nop>", opts)
vim.g.mapleader = " "

-- Clean up save file
vim.keymap.set("n", "<S-g>", "<S-g>zz", opts)
-- vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)
-- vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)
vim.keymap.set("n", "J", "mzJ`z", opts)

vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)
vim.keymap.set("n", "<C-q>", "<cmd>q<cr>", opts)
vim.keymap.set("n", "<C-s>", "<cmd>w<cr>", opts)
vim.keymap.set("n", "<S-q>", "<cmd>bd<CR>", opts)

vim.keymap.set("n", "<ESC><ESC>", "<cmd>nohlsearch<CR>", opts)

vim.keymap.set("n", "<A-j>", ":m.+1<CR>==", opts)
vim.keymap.set("n", "<A-k>", ":m.-2<CR>==", opts)
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)
vim.keymap.set("v", "<A-j>", ":m'>+1<CR>gv=gv", opts)
vim.keymap.set("v", "<A-k>", ":m'<-2<CR>gv=gv", opts)

-- vim.keymap.set("n", "`", "<cmd>ToggleTerm<CR>", opts)
vim.keymap.set("n", "<M-Bslash>", "<cmd>ToggleTerm<CR>", opts)
vim.keymap.set("x", "<M-Bslash>", "<cmd>ToggleTerm<CR>", opts)
vim.keymap.set("i", "<M-Bslash>", "<cmd>ToggleTerm<CR>", opts)

-- Maintain the cursor position when yanking a visual selection
-- http://ddrscott.github.io/blog/2016/yank-without-jank/
vim.keymap.set("v", "y", "myy`y", opts)
vim.keymap.set("v", "Y", "myY`y", opts)

-- Better escape
vim.keymap.set("i", "jj", "<ESC>", opts)

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', opts)

-- Better comments
vim.keymap.set("n", "<M-/>", '<cmd>lua require"Comment.api".toggle.linewise.current()<CR>', opts)
vim.keymap.set("x", "<M-/>", '<ESC><CMD>lua require"Comment.api".toggle.linewise(vim.fn.visualmode())<CR>', opts)
vim.keymap.set("i", "<M-/>", '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', opts)

-- Break undo sequence at punctuation marks
vim.keymap.set("i", "<space>", " <c-g>u", opts)

-- Better Undo
vim.keymap.set("i", "<M-z>", "<C-o>u", opts)
vim.keymap.set("n", "<M-z>", "u", opts)
vim.keymap.set("x", "<M-z>", "<C-o>u", opts)

-- Better Redo
vim.keymap.set("i", "<M-S-z>", "<C-o><C-r>", opts)
vim.keymap.set("n", "<M-S-z>", "<C-r>", opts)
vim.keymap.set("x", "<M-S-z>", "<C-o><C-r>", opts)

-- Better Cut
vim.keymap.set("x", "<M-x>", "x", opts)
vim.keymap.set("x", "<M-c>", "y", opts)
vim.keymap.set("x", "", "y", opts)

-- Better Copy
vim.keymap.set("", "<M-a>", "ggVG", opts)

-- Better Paste
vim.keymap.set("x", "p", "_dP", opts)

-- Better indentations
vim.keymap.set("x", "<TAB>", ">gv", opts)
vim.keymap.set("x", "<S-TAB>", "<gv", opts)
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Better formatting
vim.keymap.set("", "<M-S-f>", "<cmd>lua vim.lsp.buf.format({ async = true})<cr>")
vim.keymap.set("", "<M-f>", "<cmd>Telescope live_grep<cr>")

-- File/Buffer manipulatioU
vim.keymap.set("i", "<M-s>", "<C-o>:w<cr>", opts)
vim.keymap.set("n", "<M-s>", ":w<cr>", opts)
vim.keymap.set("x", "<M-s>", "<C-o>:w<cr>", opts)
vim.keymap.set("n", "<Leader>w", ":w<cr>", opts)
vim.keymap.set("n", "<Leader>q", ":bd<cr>", opts)
vim.keymap.set("i", "", "<C-o>u", opts)
vim.keymap.set("i", "", "<C-o>:w<cr>", opts)

-- Better window movement
vim.keymap.set("n", "<C-J>", "<C-W><C-J>", opts)
vim.keymap.set("n", "<C-K>", "<C-W><C-K>", opts)
vim.keymap.set("n", "<C-H>", "<C-W><C-H>", opts)
vim.keymap.set("n", "<C-L>", "<C-W><C-L>", opts)
-- vim.keymap.set("n", "<C-h>", "<C-w>h")
-- vim.keymap.set("n", "<C-j>", "<C-w>j")
-- vim.keymap.set("n", "<C-k>", "<C-w>k")
-- vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Better terminal movements
function _G.set_terminal_keymaps()
	vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], term_opts)
	vim.api.nvim_buf_set_keymap(0, "t", "jj", [[<C-\><C-n>]], term_opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], term_opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], term_opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], term_opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], term_opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<M-\\>", "<cmd>ToggleTerm<CR>", term_opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

vim.keymap.set("n", "<C-k>", "<cmd>Lspsaga hover_doc<cr>", opts)
vim.keymap.set("i", "<C-k>", "<cmd>Lspsaga hover_doc<cr>", opts)

-- Better multiple cursor mappings - a la vscode
vim.cmd([[
let g:VM_maps = {}
let g:VM_maps['Find Under']                  = '<M-d>'
let g:VM_maps['Find Subword Under']          = '<M-D>'
]])

if vim.g.neovide then
	vim.g.gui_font_default_size = 18
	vim.g.neovide_input_use_logo = 1 -- enable use of the logo (cmd) key
	vim.keymap.set("n", "<D-s>", ":w<CR>", opts) -- Save
	vim.keymap.set("v", "<D-c>", '"+y', opts) -- Copy
	vim.keymap.set("n", "<D-v>", '"+P', opts) -- Paste normal mode
	vim.keymap.set("v", "<D-v>", '"+P', opts) -- Paste visual mode
	vim.keymap.set("c", "<D-v>", "<C-R>+", opts) -- Paste command mode
	vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli', opts) -- Paste insert mode

	vim.g.neovide_scale_factor = 1.0
	local change_scale_factor = function(delta)
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
	end
	vim.keymap.set("n", "<C-=>", function()
		change_scale_factor(1.25)
	end)
	vim.keymap.set("n", "<C-->", function()
		change_scale_factor(1 / 1.25)
	end)

	-- Helper function for transparency formatting
	-- local alpha = function()
	--  return string.format("%x", math.floor(255 * vim.g.neovide_transparency_point or 0.8))
	-- end
	-- -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
	-- vim.g.neovide_transparency = 0.0
	-- vim.g.neovide_transparency_point = 0.5
	-- vim.g.transparency = 0.8
	-- vim.g.neovide_background_color = "#0f1117" .. alpha()

	vim.cmd([[
    set guifont=agave\ Nerd\ Font\ Mono:h16
    ]])
end

-- Allow clipboard copy paste in neovim
vim.g.neovide_input_use_logo = 1
vim.keymap.set("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
vim.keymap.set("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.keymap.set("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.keymap.set("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })

-- vim.opt.selectmode  = vim.opt.selectmode + "mouse"

-- vim.keymap.set("s", "<M-v>", '<C-o>"+y', { noremap = true })
-- vim.keymap.set("s", "<M-x>", '<C-o>"+d', { noremap = true })
