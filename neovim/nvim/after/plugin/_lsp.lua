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

local lsp_attach_group = vim.api.nvim_create_augroup('gtpv-lsp-attach', { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
        group = lsp_attach_group,
        callback = function(event)
                local opts = { buffer = event.buf, remap = false }
                local function map(mode, keys, func, desc)
                        vim.keymap.set(mode, keys, func, vim.tbl_extend('force', opts, { desc = desc }))
                end

                map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
                map('n', 'K', vim.lsp.buf.hover, 'Hover documentation')
                map('n', '<leader>vws', vim.lsp.buf.workspace_symbol, 'Workspace symbols')
                map('n', '<leader>vd', vim.diagnostic.open_float, 'Line diagnostics')
                map('n', '[d', vim.diagnostic.goto_next, 'Next diagnostic')
                map('n', ']d', vim.diagnostic.goto_prev, 'Previous diagnostic')
                map('n', '<leader>vca', vim.lsp.buf.code_action, 'Code actions')
                map('n', '<leader>vrr', vim.lsp.buf.references, 'References')
                map('n', '<leader>vrn', vim.lsp.buf.rename, 'Rename symbol')
                map('i', '<C-h>', vim.lsp.buf.signature_help, 'Signature help')
        end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local servers = { 'clangd', 'lua_ls' }

mason_lspconfig.setup({
        ensure_installed = servers,
        handlers = {
                function(server_name)
                        local opts = {
                                capabilities = capabilities,
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
