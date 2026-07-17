return {
    "karb94/neoscroll.nvim",
    config = function()
        require("neoscroll").setup({
            mappings        = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
            hide_cursor     = true,
            stop_eof        = true,
            easing_function = "sine",
        })
    end,
}
