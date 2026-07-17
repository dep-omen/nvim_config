return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        -- Disable netrw (vim's built-in file explorer) so nvim-tree takes over
        vim.g.loaded_netrw       = 1
        vim.g.loaded_netrwPlugin = 1

        require("nvim-tree").setup({
            view = {
                width = 35,
                side  = "left",
            },
            renderer = {
                group_empty = true,          -- collapse single-child dirs
                icons = {
                    show = {
                        file        = true,
                        folder      = true,
                        folder_arrow= true,
                        git         = true,
                    },
                },
            },
            filters = {
                dotfiles = false,            -- show hidden files
            },
            git = {
                enable  = true,
                ignore  = false,             -- show git-ignored files (greyed out)
            },
            actions = {
                open_file = {
                    quit_on_open = true,     -- close tree after opening a file
                },
            },
        })
    end,
}
