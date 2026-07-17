return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
        local telescope      = require("telescope")
        local actions        = require("telescope.actions")
        local previewers     = require("telescope.previewers")
        local previewers_utils = require("telescope.previewers.utils")

        -- Safe previewer: falls back to regex highlighting if treesitter fails
        local preview_maker = function(filepath, bufnr, opts)
            opts = opts or {}
            if opts.use_ft_detect == nil then opts.use_ft_detect = true end
            previewers_utils.highlighter = function(bufnr2, ft)
                local ok = pcall(function()
                    local lang = (vim.treesitter.ft_to_lang and vim.treesitter.ft_to_lang(ft))
                        or (vim.treesitter.language.get_lang and vim.treesitter.language.get_lang(ft))
                        or ft
                    vim.treesitter.start(bufnr2, lang)
                end)
                if not ok then
                    vim.bo[bufnr2].syntax = ft
                end
            end
            previewers.buffer_previewer_maker(filepath, bufnr, opts)
        end

        telescope.setup({
            defaults = {
                buffer_previewer_maker = preview_maker,
                file_ignore_patterns   = { "^.git/", "node_modules" },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        ["<Esc>"] = actions.close,
                    },
                },
            },
            pickers = {
                find_files = { hidden = true },
            },
        })

        pcall(telescope.load_extension, "fzf")
    end,
}