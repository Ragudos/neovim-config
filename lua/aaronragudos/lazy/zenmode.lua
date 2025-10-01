
local zenMode = function()
    require("zen-mode").setup {
        window = {
            width = 80,
            options = { }
        },
        zen = {
            enter = true,
            fixbuf = false,
            minimal = false,
            width = 120,
            height = 0,
            backdrop = { transparent = true, blend = 40 },
            keys = { q = false },
            zindex = 40,
            wo = {
                winhighlight = "NormalFloat:Normal",
            },
            w = {
                snacks_main = true,
            },
        }
    }
    require("zen-mode").toggle()
    SetColorTheme()
end

return {
    "folke/zen-mode.nvim",
    config = function()
        vim.keymap.set("n", "<leader>zz",zenMode)
        vim.keymap.set("n", "<leader>zZ", zenMode)
    end
}


