return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        -- nvim-treesitter v1: require("nvim-treesitter"), NOT ("nvim-treesitter.configs")
        require("nvim-treesitter").setup({
            ensure_installed = {
                "c", "cpp",        -- embedded dev
                "python",
                "lua",
                "bash",
                "cmake",
                "make",
                "devicetree",      -- .dts / .dtsi
                "json", "yaml", "toml",
                "markdown",
            },
            highlight = { enable = true },
            indent    = { enable = true },
        })
    end,
}