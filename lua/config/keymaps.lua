local map = vim.keymap.set

map("i", "jk", "<Esc>", { desc = "Exit Insert Mode" })
map({ "n", "i" }, "<C-s>", "<Cmd>write<CR>", { desc = "Save File" })

map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Buffer Diagnostics" })
map("n", "<leader>dw", vim.diagnostic.setqflist, { desc = "Workspace Diagnostics" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Previous Diagnostic" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next Diagnostic" })
