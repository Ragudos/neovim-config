local jdtls_bin = vim.fn.stdpath('data') .. '/mason/bin/jdtls'
local lsp_attach = function(jdtls, bufnr)
    -- Normal mode
end

local config = {
    cmd = { jdtls_bin },
    root_dir = vim.fs.dirname(
        vim.fs.find({'gradlew', '.git', 'mvnw'},
            { upward = true})[1]),
    on_attach = lsp_attach
}

local jdtls = require('jdtls')

jdtls.start_or_attach(config)

vim.keymap.set('n', '<A-o>', jdtls.organize_imports, { desc = 'Organize Imports' })
vim.keymap.set('n', 'crv', jdtls.extract_variable, { desc = 'Extract Variable' })
vim.keymap.set('n', 'crc', jdtls.extract_constant, { desc = 'Extract Constant' })
vim.keymap.set('n', '<leader>df', jdtls.test_class, { desc = 'Debug: Test Class' })
vim.keymap.set('n', '<leader>dn', jdtls.test_nearest_method, { desc = 'Debug: Test Nearest Method' })

-- Visual mode
vim.keymap.set('v', 'crv', function() vim.cmd("normal! <Esc>") jdtls.extract_variable(true) end, { desc = 'Extract Variable (Visual)' })
vim.keymap.set('v', 'crc', function() vim.cmd("normal! <Esc>") jdtls.extract_constant(true) end, { desc = 'Extract Constant (Visual)' })
vim.keymap.set('v', 'crm', function() vim.cmd("normal! <Esc>") jdtls.extract_method(true) end, { desc = 'Extract Method (Visual)' })

