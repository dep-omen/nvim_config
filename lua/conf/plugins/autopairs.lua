return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
        local autopairs = require("nvim-autopairs")
        autopairs.setup({ check_ts = true })   -- use treesitter for smarter pairing

        -- Make autopairs play nice with nvim-cmp:
        -- when you confirm a completion, the closing bracket is inserted correctly
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local cmp           = require("cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
}
