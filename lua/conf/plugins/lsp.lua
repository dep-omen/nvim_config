return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",

        -- Autocompletion engine
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",

        -- Snippet engine (required by nvim-cmp)
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",

        -- Nice LSP UI
        "j-hui/fidget.nvim",
    },
    config = function()

        -- ── Fidget: LSP loading spinner in bottom-right ───────────────────
        require("fidget").setup()

        -- ── Mason: auto-install servers ───────────────────────────────────
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "clangd",
                "pyright",
                "lua_ls",
                "bashls",
            },
            automatic_installation = true,
        })

        -- ── Capabilities: tell each server what nvim-cmp supports ─────────
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- ── LSP keymaps, attached whenever any LSP connects to a buffer ───
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
                end
                local tb = require("telescope.builtin")

                map("gd",         tb.lsp_definitions,      "Go to definition")
                map("gr",         tb.lsp_references,        "Go to references")
                map("gI",         tb.lsp_implementations,   "Go to implementation")
                map("K",          vim.lsp.buf.hover,        "Hover documentation")
                map("<leader>rn", vim.lsp.buf.rename,       "Rename symbol")
                map("<leader>ca", vim.lsp.buf.code_action,  "Code action")
                map("<leader>D",  tb.lsp_type_definitions,  "Type definition")
                map("[d",         vim.diagnostic.goto_prev, "Prev diagnostic")
                map("]d",         vim.diagnostic.goto_next, "Next diagnostic")
                map("<leader>d",  vim.diagnostic.open_float,"Show diagnostic")
            end,
        })

        -- ── vim.lsp.config: new API (nvim 0.11+) ─────────────────────────
        -- Sets defaults for ALL servers before they start
        vim.lsp.config("*", {
            capabilities = capabilities,
        })

        -- clangd
        vim.lsp.config("clangd", {
            cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--header-insertion=iwyu",
                "--completion-style=detailed",
                "--function-arg-placeholders",
            },
        })

        -- lua_ls: suppress "undefined global vim" warnings in this config
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    workspace   = { checkThirdParty = false },
                    telemetry   = { enable = false },
                },
            },
        })

        -- pyright and bashls: defaults are fine, no extra config needed
        -- vim.lsp.config("pyright", {})
        -- vim.lsp.config("bashls", {})

        -- ── Enable servers (replaces lspconfig.X.setup()) ─────────────────
        vim.lsp.enable({ "clangd", "pyright", "lua_ls", "bashls" })

        -- ── Diagnostic appearance ─────────────────────────────────────────
        vim.diagnostic.config({
            virtual_text     = true,
            signs            = true,
            underline        = true,
            update_in_insert = false,
            severity_sort    = true,
        })

        -- ── nvim-cmp: completion menu ─────────────────────────────────────
        local cmp     = require("cmp")
        local luasnip = require("luasnip")

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-j>"]     = cmp.mapping.select_next_item(),
                ["<C-k>"]     = cmp.mapping.select_prev_item(),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"]     = cmp.mapping.abort(),
                ["<CR>"]      = cmp.mapping.confirm({ select = true }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "path" },
            }),
        })
    end,
}