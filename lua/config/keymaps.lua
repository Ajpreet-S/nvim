local map = vim.keymap.set

-- Editing
map("i", "jk", "<Esc>", { desc = "Exit Insert Mode" })
map({ "n", "i" }, "<C-s>", "<Cmd>write<CR>", { desc = "Save File" })
map({ "n", "i" }, "<C-q>", "<Cmd>quit<CR>", { desc = "Exit Neovim" })

-- Files and search (Snacks is loaded at startup)
map("n", "<leader>e", function() Snacks.explorer() end, { desc = "File Explorer" })
map("n", "<leader>a", function() Snacks.picker.pick("all") end, { desc = "Search All" })
map("n", "<leader>f", function() Snacks.picker.pick("all", { search_mode = "files" }) end, { desc = "Search Files" })
map("n", "<leader>t", function() Snacks.picker.pick("all", { search_mode = "text" }) end, { desc = "Search Text" })

-- Bookmarks (require inside callbacks lets Lazy load Harpoon on demand)
map("n", "<leader>H", function() require("bookmarks.harpoon").add() end, { desc = "Harpoon Add File" })
map("n", "<leader>h", function() require("pickers.harpoon").open() end, { desc = "Harpoon Menu" })
map("n", "<leader>1", function() require("harpoon"):list():select(1) end, { desc = "Harpoon File 1" })
map("n", "<leader>2", function() require("harpoon"):list():select(2) end, { desc = "Harpoon File 2" })
map("n", "<leader>3", function() require("harpoon"):list():select(3) end, { desc = "Harpoon File 3" })
map("n", "<leader>4", function() require("harpoon"):list():select(4) end, { desc = "Harpoon File 4" })
map("n", "<leader>5", function() require("harpoon"):list():select(5) end, { desc = "Harpoon File 5" })

-- Git and tasks
map("n", "<leader>g", function() Snacks.lazygit() end, { desc = "LazyGit" })
map("n", "<leader>m", function() require("pickers.mise").open() end, { desc = "Mise Tasks" })

-- Code
map({ "n", "x" }, "<leader>cf", function()
    require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format Code" })

-- LSP shortcuts apply only to buffers with an attached language server.
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LanguageKeymaps", { clear = true }),
    callback = function(event)
        local function lsp_map(lhs, rhs, desc)
            map("n", lhs, rhs, { buffer = event.buf, desc = desc })
        end
        lsp_map("gd", vim.lsp.buf.definition, "Go to Definition")
        lsp_map("gD", vim.lsp.buf.declaration, "Go to Declaration")
        lsp_map("gr", vim.lsp.buf.references, "Find References")
        lsp_map("gI", vim.lsp.buf.implementation, "Go to Implementation")
        lsp_map("gy", vim.lsp.buf.type_definition, "Go to Type Definition")
        lsp_map("K", vim.lsp.buf.hover, "Hover Documentation")
        lsp_map("<leader>cr", vim.lsp.buf.rename, "Rename Symbol")
        lsp_map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
        lsp_map("<leader>cs", vim.lsp.buf.signature_help, "Signature Help")
    end,
})

-- Diagnostics
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Buffer Diagnostics" })
map("n", "<leader>dw", vim.diagnostic.setqflist, { desc = "Workspace Diagnostics" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Previous Diagnostic" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next Diagnostic" })

-- Discover mappings
map("n", "<leader>?", function() require("which-key").show({ global = true }) end, { desc = "Show Keymaps" })
