-- Completion ----------------------------------------------------------------

vim.g.mapleader = ","

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local cmp = require('cmp')
cmp.setup {
    view = { entries = "wildmenu" },
    confirmation = { completeopt = 'menu,menuone,noinsert' },
    preselect = cmp.PreselectMode.None,
    mapping = {
        ['<C-Space>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        },

        ['<Tab>'] = function(fallback)
            if not cmp.select_next_item() then
                if vim.bo.buftype ~= 'prompt' and has_words_before() then
                    cmp.complete()
                    --cmp.confirm({ select = true })
                else
                    fallback()
                end
            end
        end,

        ['<S-Tab>'] = function(fallback)
            if not cmp.select_prev_item() then
                if vim.bo.buftype ~= 'prompt' and has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end
        end,
    },
    sources = {
        { name = 'nvim_lsp' },
    },
    snippet = {},
}
local capabilities = require('cmp_nvim_lsp').default_capabilities({ snippetSupport = false })

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    --vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    --vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
    --vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    --vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'K', function()
        local line_num = vim.api.nvim_win_get_cursor(0)[1] - 1
        local diagnostics = vim.diagnostic.get(0, { lnum = line_num })

        if not vim.tbl_isempty(diagnostics) then
            vim.diagnostic.open_float({ border = "rounded" })
        else
            vim.lsp.buf.hover({ border = "rounded" })
        end
    end, bufopts)
    --vim.keymap.set('n', '<leader>K', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    --vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
end

vim.lsp.config("clangd", { capabilities = capabilities, on_attach = on_attach })
vim.lsp.enable("clangd")

vim.lsp.config("rust_analyzer", { capabilities = capabilities, on_attach = on_attach })
vim.lsp.enable("rust_analyzer")

vim.diagnostic.enable(true)

vim.diagnostic.config({
    virtual_text = false,     -- disable inline text
    signs = true,             -- keep signs in the sign column
    underline = true,         -- underline problematic code
    update_in_insert = false,
    severity_sort = true,
})

-- Disable semantic highlighting
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        client.server_capabilities.semanticTokensProvider = nil
    end,
});

-- Telescope -----------------------------------------------------------------

local builtin = require('telescope.builtin')

local function list_files()
    local ok = pcall(builtin.git_files, { show_untracked = true })

    -- search with everything.exe
    -- builtin..findfiles { find_command = { "es.exe", "-matchpath", vim.loop.cwd() } }

    if not ok then
        builtin.find_files()
    end
end

vim.keymap.set('n', '<C-p>', list_files)
vim.keymap.set('n', '<leader>o', builtin.oldfiles)
vim.keymap.set('n', '<leader>g', builtin.live_grep)

require('telescope').setup {
    defaults = {
        preview = true,
        layout_config = {
            vertical = { width = 80, height = 0.6, preview_height = 0.5 }
        },
        file_ignore_patterns = {
            "build/",
            "bin",
            ".vs",
            ".cache",
            ".git",
            ".cargo",
            "target",
            "compile_commands.json",
        }
    },
    pickers = {
        find_files = {
            previewer = false,
            layout_strategy = 'vertical', -- flex for preview = true
        },
        git_files = {
            previewer = false,
            layout_strategy = 'vertical',
        },
        buffers = {
            previewer = false,
        },
        live_grep = {
            previewer = true,
            layout_strategy = 'flex', -- flex = { flip_columns = 120 }
        },
    },
}
