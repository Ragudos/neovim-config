require("aaronragudos.set")
require("aaronragudos.remap")
require("aaronragudos.lazy_init")

local augroup = vim.api.nvim_create_augroup
local AaronRagudosGroup = augroup('aaronragudos', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

-- remove all trailing whitespaces from all lines silently
autocmd({"BufWritePre"}, {
    group = AaronRagudosGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd('BufEnter', {
    group = AaronRagudosGroup,

    callback = function()
        vim.cmd.colorscheme("rose-pine")
    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

