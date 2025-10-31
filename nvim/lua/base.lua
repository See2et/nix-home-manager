vim.cmd.colorscheme("tokyonight")

local opt = vim.opt

opt.clipboard:append { 'unnamedplus' }

opt.writebackup = false
opt.backup = false
opt.swapfile = false

opt.cursorline = true
opt.number = false
opt.showmatch = true

opt.expandtab = true
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4
opt.smartindent = true
opt.autoindent = true
opt.hlsearch = true

opt.laststatus = 3
opt.scrolloff = 10

opt.mouse = 'a'

opt.cmdheight = 0

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    command = "lua vim.lsp.buf.format()"
})

vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = false, underline = false, bg = "#3b0000" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = false, underline = false, bg = "#3b2f00" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = false, underline = false, bg = "#003b3b" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = false, underline = false, bg = "#002f3b" })

vim.diagnostic.config({
    underline = true,
    virtual_text = false,
    severity_sort = true,
})
