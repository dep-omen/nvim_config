local opt = vim.opt

-- Line numbers
opt.number         = true
opt.relativenumber = true

-- Tabs / indentation
opt.tabstop        = 4
opt.shiftwidth     = 4
opt.expandtab      = true
opt.smartindent    = true

-- Appearance
opt.termguicolors  = true
opt.signcolumn     = "yes"   -- always show gutter (gitsigns / LSP icons)
opt.cursorline     = true
opt.scrolloff      = 8       -- keep 8 lines above/below cursor
opt.wrap           = false

-- Search
opt.ignorecase     = true
opt.smartcase      = true    -- case-sensitive if you type a capital
opt.hlsearch       = false   -- no persistent highlight after search
opt.incsearch      = true

-- System clipboard
opt.clipboard      = "unnamedplus"

-- Splits open to the right / below (feels more natural)
opt.splitright     = true
opt.splitbelow     = true

-- Faster key response
opt.timeoutlen     = 300
opt.updatetime     = 250

-- Undo history survives restarts
opt.undofile       = true

-- No swap files cluttering your project dirs
opt.swapfile       = false
opt.backup         = false

-- Auto-set makeprg for C files based on current filename
vim.api.nvim_create_autocmd("FileType", {
    pattern = "c",
    callback = function()
        local filename = vim.fn.expand("%:t:r")   -- filename without extension
        vim.opt.makeprg = "gcc % -o " .. filename
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "cpp",
    callback = function()
        local filename = vim.fn.expand("%:t:r")
        vim.opt.makeprg = "g++ % -o " .. filename
    end,
})