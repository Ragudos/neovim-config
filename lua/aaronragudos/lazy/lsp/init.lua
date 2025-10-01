local root_files = {
  '.luarc.json',
  '.luarc.jsonc',
  '.luacheckrc',
  '.stylua.toml',
  'stylua.toml',
  'selene.toml',
  'selene.yml',
  '.git',
}

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        'mfussenegger/nvim-jdtls',

        "glepnir/lspsaga.nvim",
        "ray-x/lsp_signature.nvim",
        "nvim-lua/lsp_extensions.nvim",
    },

    config = function()
        require("conform").setup({
            formatters_by_ft = {
            }
        })

        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        capabilities.textDocument.completion.completionItem.snippetSupport = true
        capabilities.textDocument.completion.completionItem.resolveSupport = {
            properties = { "documentation", "detail", "additionalTextEdits" },
        }

        local lsp_attach = function(client, bufnr)
             -- enable signature help
            require("lsp_signature").on_attach({}, bufnr)

            -- enable inlay hints if available
            local ok, lsp_ext = pcall(require, "lsp_extensions")
            if ok then
                vim.api.nvim_create_autocmd(
                    { "CursorMoved", "InsertLeave", "BufEnter", "BufWinEnter", "TabEnter", "BufWritePost" },
                    {
                        buffer = bufnr,
                        callback = function()
                            lsp_ext.inlay_hints { prefix = " » ", highlight = "Comment" }
                        end,
                    }
                )
            end

             -- keymaps (example, you can expand)
            local opts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
            vim.keymap.set("n", "<leader>r", "<cmd>Lspsaga rename<CR>", opts)
            vim.keymap.set("n", "<leader>a", "<cmd>Lspsaga code_action<CR>", opts)
            vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
            vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
        end

        -- signs (instead of utils.get_icon, just use icons directly)
        vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticError" })
        vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticWarn" })
        vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticInfo" })
        vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticHint" })

        require("fidget").setup({})
        require("mason").setup()

        local lspconfig = require("lspconfig")
        local util = require("lspconfig.util")

        local noop = function()
        end

        local tailwindcss = function()
            lspconfig.tailwindcss.setup({
                capabilities = capabilities,
                on_attach = lsp_attach,
                filetypes = {
                    "aspnetcorerazor", "blade", "django-html", "edge", "ejs", "eruby", "gohtml",
                    "haml", "handlebars", "hbs", "html", "html-eex", "jade", "leaf", "liquid",
                    "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig",
                    "css", "less", "postcss", "sass", "scss", "stylus", "sugarss",
                    "javascript", "javascript.jsx", "javascriptreact", "reason", "rescript",
                    "typescript", "typescript.tsx", "typescriptreact",
                    "vue", "svelte",
                },
                init_options = {
                    userLanguages = {
                        eruby = "html",
                        ["javascript.jsx"] = "javascriptreact",
                        ["typescript.tsx"] = "typescriptreact",
                    },
                },
                root_dir = function(fname)
                    return util.root_pattern("tailwind.config.js", "tailwind.config.ts")(fname)
                        or util.root_pattern("postcss.config.js", "postcss.config.ts")(fname)
                        or util.find_package_json_ancestor(fname)
                        or util.find_node_modules_ancestor(fname)
                        or util.find_git_ancestor(fname)
                end,
                handlers = {
                    ["tailwindcss/getConfiguration"] = function(_, _, params, _, bufnr)
                        vim.lsp.buf_notify(bufnr, "tailwindcss/getConfigurationResponse", { _id = params._id })
                    end,
                },
            })
        end

        local jsonls = function()
            lspconfig.jsonls.setup({
                capabilities = capabilities,
                on_attach = lsp_attach,
                settings = {
                    json = {
                        schemas = {
                          {
                            fileMatch = {"package.json"},
                            url = "https://json.schemastore.org/package.json"
                          },
                          {
                            fileMatch = {"tsconfig*.json", "jsconfig*.json"},
                            url = "https://json.schemastore.org/tsconfig.json"
                          },
                          {
                            fileMatch = {
                              ".prettierrc",
                              ".prettierrc.json",
                              "prettier.config.json"
                            },
                            url = "https://json.schemastore.org/prettierrc.json"
                          },
                          {
                            fileMatch = {".eslintrc", ".eslintrc.json"},
                            url = "https://json.schemastore.org/eslintrc.json"
                          },
                          {
                            fileMatch = {".babelrc", ".babelrc.json", "babel.config.json"},
                            url = "https://json.schemastore.org/babelrc.json"
                          },
                          {
                            fileMatch = {"lerna.json"},
                            url = "https://json.schemastore.org/lerna.json"
                          },
                          {
                            fileMatch = {"now.json", "vercel.json"},
                            url = "https://json.schemastore.org/now.json"
                          },
                          {
                            fileMatch = {
                              ".stylelintrc",
                              ".stylelintrc.json",
                              "stylelint.config.json"
                            },
                            url = "http://json.schemastore.org/stylelintrc.json"
                          },
                        },
                        validate = { enable = true }
                    }
                }
            })
        end

        local yamlls = function()
            lspconfig.yamlls.setup({
                capabilities = capabilities,
                on_attach = lsp_attach,
                settings = {
                    yaml = {
                        schemas = {
                            ["http://json.schemastore.org/gitlab-ci.json"] = {".gitlab-ci.yml"},
                            ["https://json.schemastore.org/bamboo-spec.json"] = {
                                "bamboo-specs/*.{yml,yaml}"
                            },
                            ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
                                "docker-compose*.{yml,yaml}"
                            },
                            ["http://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.{yml,yaml}",
                            ["http://json.schemastore.org/github-action.json"] = ".github/action.{yml,yaml}",
                            ["http://json.schemastore.org/prettierrc.json"] = ".prettierrc.{yml,yaml}",
                            ["http://json.schemastore.org/stylelintrc.json"] = ".stylelintrc.{yml,yaml}",
                            ["http://json.schemastore.org/circleciconfig"] = ".circleci/**/*.{yml,yaml}"
                        }
                    }
                }
            })
        end

        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "gopls",
                "lua_ls",
                "rust_analyzer",
                "gopls",
                "jsonls",
                "yamlls",
                "ts_ls",
                "tailwindcss",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities,
                        on_attach = lsp_attach
                    }
                end,

                ["tailwindcss"] = tailwindcss,
                ['jdtls'] = noop,
                ["jsonls"] = jsonls,
                ["yamlls"] = yamlls
            }
       })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })


        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                style = '',
                focusable = false,
                border = "rounded",
                header = "",
                prefix = "",
            },
        })

         -- debugging helpers (call in command mode)
        vim.api.nvim_create_user_command("LspDebug", function()
            vim.lsp.set_log_level("debug")
            print("LSP log: " .. vim.lsp.get_log_path())
        end, {})
    end
}
