return {
    'Dynge/gitmoji.nvim',
    dependencies = {
        "hrsh7th/nvim-cmp", -- for nvim-cmp completion
        "Saghen/blink.cmp", -- for blink completion
    },
    opts = {
        filetypes = { 'gitcommit' },
        completion = {
            append_space = false,
            complete_as = 'emoji',
        },
    },
    ft = 'gitcommit'
}
