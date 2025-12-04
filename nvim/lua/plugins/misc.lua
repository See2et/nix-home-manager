return {
    {
        "folke/zen-mode.nvim",
        cmd = { "ZenMode" }
    },

    {
        'folke/which-key.nvim',
        lazy = false,
        dependencies = {
            { 'echasnovski/mini.nvim', version = false },
            'nvim-tree/nvim-web-devicons'
        }
    },

    {
        'akinsho/toggleterm.nvim',
        cmd = { "ToggleTerm" },
        version = "*",
        config = function()
            require('toggleterm').setup {
                direction = 'float',
                shell = 'fish',
                float_opts = {
                    border = 'curved'
                }
            }
        end
    },

    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-file-browser.nvim',
        },
        config = function()
            require('telescope').setup {
                defaults = {
                    previewer = true,
                    mappings = {
                        n = {
                            ["<C-[>"] = require('telescope.actions').close,
                            ["<leader>q"] = require('telescope.actions').close,
                        },
                        i = {
                            ['<C-u>'] = false,
                            ['<C-d>'] = false,
                            ["<leader>q"] = require('telescope.actions').close,
                        },
                    },
                },
                extensions = {
                    file_browser = {
                        theme = "dropdown",
                        hijack_netrw = true,
                        mappings = {
                            ["i"] = {
                                ["<C-w>"] = function() vim.cmd('normal vbd') end,
                            },
                            ["n"] = {
                                -- your custom normal mode mappings
                                ["N"] = require("telescope").extensions.file_browser.actions.create,
                                ["h"] = require("telescope").extensions.file_browser.actions.goto_parent_dir,
                                ["/"] = function()
                                    vim.cmd('startinsert')
                                end
                            },
                        },
                        path = "%:p:h",
                        cwd = vim.fn.expand('%:p:h'),
                        respect_gitignore = false,
                        hidden = true,
                        grouped = true,
                        initial_mode = "normal",
                        layout_config = { height = 40 }
                    },
                },
            }
            require('telescope').load_extension('noice')
            require('telescope').load_extension('file_browser')
        end
    },

    {
        'phaazon/hop.nvim',
        cmd = {
            "HopWord",
            "HopLineStart",
            "HopLine",
            "HopChar2",
            "HopAnywhere"
        },
        config = function()
            require('hop').setup()
        end
    },

    {
        'lewis6991/gitsigns.nvim',
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require('gitsigns').setup {}
        end,
    },

    {
        "shellRaining/hlchunk.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("hlchunk").setup({
                chunk = {
                    enable = true,
                    style = "#00ffff",
                },
                indent = {
                    enable = true,
                    chars = {
                        "│",
                    },
                    style = { vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui") }
                }
            })
        end
    },

    {
        "norcalli/nvim-colorizer.lua",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("colorizer").setup()
        end,
    },

    {
        "windwp/nvim-autopairs",
        event = { "InsertEnter" },
        config = function()
            require("nvim-autopairs").setup()
        end,
    },

    {
        "j-hui/fidget.nvim",
    },

    {
        "folke/noice.nvim",
        event = "VeryLazy",
        config = function()
            require("noice").setup({
                lsp = {
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = true,         -- use a classic bottom cmdline for search
                    command_palette = true,       -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = false,       -- add a border to hover docs and signature help
                },
            })
        end,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        }
    },

    {
        "akinsho/bufferline.nvim",
        config = function()
            require("bufferline").setup({
                options = {
                    mode = "tabs",
                    separator_style = 'slant',
                    always_show_bufferline = false,
                    show_buffer_close_icons = false,
                    show_close_icon = false,
                    color_icons = true
                },
                highlights = {
                    separator = {
                        fg = '#073642',
                        bg = '#002b36'
                    },
                    separator_selected = {
                        fg = '#073642',
                    },
                    background = {
                        fg = '#657b83',
                        bg = '#002b36'
                    },
                    buffer_selected = {
                        fg = '#fdf6e3',
                        bold = true,
                    },
                    fill = {
                        bg = '#073642'
                    }
                },
            })
        end,
    },

    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    auto_trigger = true,
                    keymap = {
                        accept = "<Tab>",
                    },
                },
            })
        end,
    },

    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        priority = 1000,
        config = function()
            require("tiny-inline-diagnostic").setup({
                preset = "modern",
                options = {
                    multilines = {
                        enabled = true,
                    },
                    break_line = {
                        enabled = true,
                    }
                }
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require("treesitter-context").setup {
                enable = true,
                multiwindows = true,
            }
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        }
    },

    {
        "stevearc/oil.nvim",
        cmd = { "Oil" },
        dependencies = { { "nvim-mini/mini.icons" } },
        lazy = false,
        config = function()
            require("oil").setup({
                default_file_explorer = false,
                float = {
                    border = "rounded",
                    max_width = 100,
                    max_height = 200,
                    preview_split = "right",
                },
                view_options = {
                    show_hidden = true,
                },
            })
        end,
    },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            lazygit = {
                enabled = true,
            },
            gh = {
                enabled = true,
            },
            dashboard = {
                enabled = true,
                width = 60,
                row = nil,                                                                   -- dashboard position. nil for center
                col = nil,                                                                   -- dashboard position. nil for center
                pane_gap = 4,                                                                -- empty columns between vertical panes
                autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
                -- These settings are used by some built-in sections
                preset = {
                    -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
                    ---@type fun(cmd:string, opts:table)|nil
                    pick = nil,
                    -- Used by the `keys` section to show keymaps.
                    -- Set your custom keymaps here.
                    -- When using a function, the `items` argument are the default keymaps.
                    ---@type snacks.dashboard.Item[]
                    keys = {
                        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                        { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                        { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                        { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
                        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                    },
                    -- Used by the `header` section
                    header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
                },
                -- item field formatters
                formats = {
                    icon = function(item)
                        if item.file and item.icon == "file" or item.icon == "directory" then
                            return Snacks.dashboard.icon(item.file, item.icon)
                        end
                        return { item.icon, width = 2, hl = "icon" }
                    end,
                    footer = { "%s", align = "center" },
                    header = { "%s", align = "center" },
                    file = function(item, ctx)
                        local fname = vim.fn.fnamemodify(item.file, ":~")
                        fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
                        if #fname > ctx.width then
                            local dir = vim.fn.fnamemodify(fname, ":h")
                            local file = vim.fn.fnamemodify(fname, ":t")
                            if dir and file then
                                file = file:sub(-(ctx.width - #dir - 2))
                                fname = dir .. "/…" .. file
                            end
                        end
                        local dir, file = fname:match("^(.*)/(.+)$")
                        return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or
                            { { fname, hl = "file" } }
                    end,
                },
                sections = {
                    { section = "header" },
                    { section = "startup", padding = 2, indent = 2 },
                    { icon = " ", title = "Recent Files", section = "recent_files", padding = 2, indent = 2 },
                    {
                        icon = " ",
                        title = "Git Status",
                        cmd = "git --no-pager diff --stat -B -M -C",
                        height = 10,
                        section = "terminal",
                        padding = 3,
                        ttl = 5 * 60,
                        indent = 3,
                    },
                    function()
                        local in_git = Snacks.git.get_root() ~= nil
                        local cmds = {
                            {
                                title = "Notifications",
                                cmd = "gh notify -s -a -n5",
                                action = function()
                                    vim.ui.open("https://github.com/notifications")
                                end,
                                key = "n",
                                icon = " ",
                                height = 5,
                                enabled = true,
                            },
                            {
                                title = "Open Issues",
                                cmd = "gh issue list -L 3",
                                key = "i",
                                action = function()
                                    vim.fn.jobstart("gh issue list --web", { detach = true })
                                end,
                                icon = " ",
                                height = 7,
                            },
                            {
                                icon = " ",
                                title = "Open PRs",
                                cmd = "gh pr list -L 3",
                                key = "P",
                                action = function()
                                    vim.fn.jobstart("gh pr list --web", { detach = true })
                                end,
                                height = 7,
                            },
                        }
                        return vim.tbl_map(function(cmd)
                            return vim.tbl_extend("force", {
                                pane = 2,
                                section = "terminal",
                                enabled = in_git,
                                padding = 3,
                                ttl = 5 * 60,
                                indent = 3,
                            }, cmd)
                        end, cmds)
                    end,
                },
            },
        }
    }
}
