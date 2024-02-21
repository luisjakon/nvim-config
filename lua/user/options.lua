-- Options
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.ignorecase = true
vim.opt.showmode = false
vim.opt.cmdheight = 1
vim.opt.showcmd = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 20
vim.opt.list = true
-- vim.opt.listchars = { space = " ", tab = "  " }
-- Special characters for highlighting non-printing spaces/tabs/etc
-- Characters configs. Sample: eol:↓, eol:¬, eol:↲, eol:⏎, tab:␉·, trail:␠, nbsp:⎵
vim.opt.list = false -- show special characters
vim.opt.listchars = {
	eol = "↲",
	tab = "▸ ",
	trail = "·",
	extends = "»",
	precedes = "«",
	nbsp = "⎵",
	conceal = "×",
}
-- vim.opt.fillchars:append {
--   horiz = '━',
--   horizup = '┻',
--   horizdown = '┳',
--   vert = '┃',
--   vertleft = '┨',
--   vertright = '┣',
--   verthoriz = '╋',
--   -- vert = ' ',
--   eob = ' ',
--   -- fold = " ",
--   foldopen = "",
--   -- foldsep = " ",
--   foldclose = "",
-- }

-- clipboard
vim.opt.clipboard:append({ "unnamed", "unnamedplus" })

-- window
vim.opt.splitbelow = true
vim.opt.splitright = true

-- backup
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.updatetime = 300

-- sessions
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- indent
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.softtabstop = 4
vim.opt.breakindent = true

-- word wrap
vim.opt.textwidth = 120
vim.opt.wrapmargin = 120 --Enable line wrap
vim.opt.wrap = false
vim.opt.linebreak = true --Break lines at word (requires Wrap lines)
vim.opt.ruler = true --Show row and column ruler information
vim.opt.showbreak = "+++" --Wrap-broken line prefix

-- folding
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldcolumn = "1"
vim.o.foldenable = true
-- vim.o.foldminlines = 1

-- vim.opt.foldcolumn = "auto:1"
-- vim.opt.fillchars:append({
--  -- foldsep = "🮍",
--  foldsep = " ",
--  foldopen = "",
--  foldclose = "",
-- })
--
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

-- edit
vim.opt.spelllang = "en,pt"
-- vim.opt.virtualedit = "all"
vim.opt.whichwrap = vim.opt.whichwrap + "<,>,[,]"

-- theme
vim.api.nvim_command("colorscheme slate")

-- Fix common typos
vim.cmd([[
    cnoreabbrev W! w!
    cnoreabbrev W1 w!
    cnoreabbrev w1 w!
    cnoreabbrev Q! q!
    cnoreabbrev Q1 q!
    cnoreabbrev q1 q!
    cnoreabbrev Qa! qa!
    cnoreabbrev Qall! qall!
    cnoreabbrev Wa wa
    cnoreabbrev Wq wq
    cnoreabbrev wQ wq
    cnoreabbrev WQ wq
    cnoreabbrev wq1 wq!
    cnoreabbrev Wq1 wq!
    cnoreabbrev wQ1 wq!
    cnoreabbrev WQ1 wq!
    cnoreabbrev W w
    cnoreabbrev Q q
    cnoreabbrev Qa qa
    cnoreabbrev Qall qall
]])

-- Just in case
vim.cmd([[
    set autoindent
    set expandtab
]])
vim.api.nvim_command("filetype plugin indent on")
