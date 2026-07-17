return {
    "folke/tokyonight.nvim",
    priority = 1000, -- load before everything else
    config = function()
        require("tokyonight").setup({
            style       = "night",   -- night | storm | moon | day
            transparent = false,
            styles = {
                comments = { italic = true },
                keywords = { italic = false },
            },
        })
        vim.cmd.colorscheme("tokyonight-night")
    end,
}
