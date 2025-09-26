local mason = require('mason')
mason.setup()

local mason_lspconfig = require('mason-lspconfig')

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local luasnip = require('luasnip')

require('luasnip.loaders.from_vscode').lazy_load()

local cmp_mappings = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

cmp.setup({
        snippet = {
                expand = function(args)
                        luasnip.lsp_expand(args.body)
                end,
        },
        mapping = cmp_mappings,
        sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'buffer' },
                { name = 'path' },
        }),
})

local signs = { Error = '✘', Warn = '▲', Hint = '⚑', Info = 'i' }
for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl })
end

vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = 'rounded' },
})

local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr, remap = false }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>vrr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename, opts)
        vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local servers = { 'clangd', 'lua_ls' }

mason_lspconfig.setup({
        ensure_installed = servers,
        handlers = {
                function(server_name)
                        local opts = {
                                capabilities = capabilities,
                                on_attach = on_attach,
                        }

                        if server_name == 'lua_ls' then
                                opts.settings = {
                                        Lua = {
                                                diagnostics = { globals = { 'vim' } },
                                                workspace = { checkThirdParty = false },
                                                telemetry = { enable = false },
                                        },
                                }
                        elseif server_name == 'clangd' then
                                opts.cmd = {
                                        'clangd',
                                        '--offset-encoding=utf-16',
                                        '--clang-tidy=',
                                        '--background-index',
                                }
                        end

                        require('lspconfig')[server_name].setup(opts)
                end,
        },
})
