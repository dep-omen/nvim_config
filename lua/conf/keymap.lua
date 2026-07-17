local map = vim.keymap.set

-- Leader key = Space
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- ── General ────────────────────────────────────────────────────────────────

-- Save & quit shortcuts
map("n", "<leader>w", "<cmd>w<CR>",  { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>",  { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<CR>",{ desc = "Force quit all" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Move selected lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centred when jumping / searching
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centred)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centred)" })
map("n", "n",     "nzzzv",   { desc = "Next match (centred)" })
map("n", "N",     "Nzzzv",   { desc = "Prev match (centred)" })

-- Better paste: don't lose register when pasting over selection
map("x", "<leader>p", '"_dP', { desc = "Paste without losing register" })

-- ── Window navigation ──────────────────────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })

-- ── File tree ─────────────────────────────────────────────────────────────
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })

-- ── Telescope ─────────────────────────────────────────────────────────────
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>",  { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",   { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>",     { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>",   { desc = "Help tags" })

-- ── LSP (set in lsp.lua on_attach, listed here for reference) ─────────────
-- gd  → go to definition
-- gr  → go to references
-- K   → hover documentation
-- <leader>rn → rename symbol
-- <leader>ca → code action
-- [d / ]d → prev/next diagnostic
