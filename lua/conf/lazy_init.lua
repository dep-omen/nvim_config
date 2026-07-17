-- Bootstrap lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- each file in plugins/ returns a plugin spec table
    { import = "conf.plugins" },
}, {
    checker = {
        enabled = true,   -- auto-check for plugin updates
        notify  = false,  -- don't pop up on startup
    },
    change_detection = {
        notify = false,
    },
})
