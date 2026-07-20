return {
    "mfussenegger/nvim-dap",
    dependencies = {
        -- UI panels (variables, stack, breakpoints, console)
        "rcarriga/nvim-dap-ui",
        -- required by nvim-dap-ui
        "nvim-neotest/nvim-nio",
        -- shows variable values inline in the code
        "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
        local dap    = require("dap")
        local dapui  = require("dapui")

        -- ── Virtual text: show values next to variables ───────────────────
        require("nvim-dap-virtual-text").setup({
            commented = true,   -- show as comment so it doesn't look like code
        })

        -- ── DAP UI layout ─────────────────────────────────────────────────
        dapui.setup({
            layouts = {
                {
                    elements = {
                        { id = "scopes",      size = 0.40 }, -- local variables
                        { id = "breakpoints", size = 0.20 },
                        { id = "stacks",      size = 0.25 }, -- call stack
                        { id = "watches",     size = 0.15 },
                    },
                    size     = 40,
                    position = "left",
                },
                {
                    elements = {
                        { id = "repl",    size = 0.5 },  -- GDB console
                        { id = "console", size = 0.5 },
                    },
                    size     = 12,
                    position = "bottom",
                },
            },
        })

        -- Auto open/close UI when debug session starts/ends
        dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
        dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
        dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end

        -- ── GDB adapter for native Linux C/C++ ───────────────────────────
        dap.adapters.gdb = {
            type    = "executable",
            command = "gdb",
            args    = { "--interpreter=dap", "--eval-command", "set print pretty on" },
        }

        -- ── Default config: auto-detect binary next to source file ────────
        dap.configurations.c = {
            {
                name    = "Debug current binary",
                type    = "gdb",
                request = "launch",
                program = function()
                    -- looks for compiled binary with same name as the source file
                    local binary = vim.fn.expand("%:p:r")
                    if vim.fn.filereadable(binary) == 1 then
                        return binary
                    end
                    -- fallback: ask user
                    return vim.fn.input("Binary path: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd            = "${workspaceFolder}",
                stopAtBeginningOfMainSubprogram = false,
            },
            {
                name    = "Debug with args",
                type    = "gdb",
                request = "launch",
                program = function()
                    return vim.fn.input("Binary path: ", vim.fn.getcwd() .. "/", "file")
                end,
                args = function()
                    local args = vim.fn.input("Args: ")
                    return vim.split(args, " ")
                end,
                cwd            = "${workspaceFolder}",
                stopAtBeginningOfMainSubprogram = false,
            },
        }

        -- reuse C config for C++
        dap.configurations.cpp = dap.configurations.c

        -- ── Keymaps ───────────────────────────────────────────────────────
        local map = vim.keymap.set

        -- Start / stop
        map("n", "<leader>ds", dap.continue,          { desc = "Debug: Start / Continue" })
        map("n", "<leader>dq", dap.terminate,         { desc = "Debug: Stop" })
        map("n", "<leader>dr", dap.restart,           { desc = "Debug: Restart" })

        -- Step controls
        map("n", "<F5>",  dap.continue,               { desc = "Debug: Continue" })
        map("n", "<F10>", dap.step_over,              { desc = "Debug: Step over" })
        map("n", "<F11>", dap.step_into,              { desc = "Debug: Step into" })
        map("n", "<F12>", dap.step_out,               { desc = "Debug: Step out" })

        -- Breakpoints
        map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle breakpoint" })
        map("n", "<leader>dB", function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end, { desc = "Debug: Conditional breakpoint" })

        -- UI
        map("n", "<leader>du", dapui.toggle,          { desc = "Debug: Toggle UI" })
        map("n", "<leader>de", dapui.eval,            { desc = "Debug: Eval expression" })
        -- hover over variable in normal/visual mode to inspect it
        map({ "n", "v" }, "<leader>dh", function()
            require("dap.ui.widgets").hover()
        end, { desc = "Debug: Hover variable" })
    end,
}
