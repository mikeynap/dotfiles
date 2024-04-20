local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    return
end

telescope.load_extension("ui-select")
telescope.load_extension("file_browser")
telescope.load_extension('fzf')
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local utils = require "telescope.utils"
local builtin = require("telescope.builtin")


telescope.setup {
    defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        -- path_display = { "shorten" },
        mappings = {
            i = {
                ["<C-n>"] = actions.cycle_history_next,
                ["<C-p>"] = actions.cycle_history_prev,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-c>"] = actions.close,
                ["<Down>"] = actions.move_selection_next,
                ["<Up>"] = actions.move_selection_previous,
                ["<CR>"] = actions.select_default,
                ["<C-x>"] = actions.select_horizontal,
                ["<C-v>"] = actions.select_vertical,
                ["<C-t>"] = actions.select_tab,
                ["<C-u>"] = actions.preview_scrolling_up,
                ["<C-d>"] = actions.preview_scrolling_down,
                ["<PageUp>"] = actions.results_scrolling_up,
                ["<PageDown>"] = actions.results_scrolling_down,
                ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                ["<C-l>"] = actions.complete_tag,
                ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
            },
            n = {
                ["<esc>"] = actions.close,
                ["<CR>"] = actions.select_default,
                ["<C-x>"] = actions.select_horizontal,
                ["<C-v>"] = actions.select_vertical,
                ["<C-t>"] = actions.select_tab,
                ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                ["j"] = actions.move_selection_next,
                ["k"] = actions.move_selection_previous,
                ["H"] = actions.move_to_top,
                ["M"] = actions.move_to_middle,
                ["L"] = actions.move_to_bottom,
                ["<Down>"] = actions.move_selection_next,
                ["<Up>"] = actions.move_selection_previous,
                ["gg"] = actions.move_to_top,
                ["G"] = actions.move_to_bottom,
                ["<C-u>"] = actions.preview_scrolling_up,
                ["<C-d>"] = actions.preview_scrolling_down,
                ["<PageUp>"] = actions.results_scrolling_up,
                ["<PageDown>"] = actions.results_scrolling_down,
                ["?"] = actions.which_key,
            },
        },
    },
    pickers = {
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        find_files = {
            theme = "ivy",
        }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {
                -- even more opts
                width = 0.8,
                previewer = false,
                prompt_title = false,
                borderchars = {
                    { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                    prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
                    results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
                    preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                },
            }
        },
        fzf = {
          fuzzy = true,                    -- false will only do exact matching
          override_generic_sorter = true,  -- override the generic sorter
          override_file_sorter = true,     -- override the file sorter
          case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                           -- the default case_mode is "smart_case"
        },
        -- Your extension configuration goes here:
        -- extension_name = {
        --   extension_config_key = value,
        -- }
        -- please take a look at the readme of the extension you want to configure
    },
}

local opts = { noremap = true, silent = true }

--nnoremap <C-f> <cmd>Telescope live_grep search_dirs=["cpp","python","gitlab"]<cr>
--nnoremap <Leader>[ <cmd>Telescope live_grep search_dirs=[expand("%:h")]<cr>

--nnoremap <C-p> <cmd>Telescope find_files search_dirs=["cpp","python","gitlab"]<cr>
--nnoremap <Leader>p <cmd>Telescope find_files search_dirs=[expand("%:h")]<cr>

--nnoremap <Leader><space> <cmd>Telescope live_grep <cr>
--nnoremap <C-t> <cmd>Telescope find_files <cr>

-- vim.api.nvim_set_keymap("n", "<leader>e", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", opts)
vim.keymap.set("n", "<leader>th", function() builtin.help_tags() end, opts)

-- Telescope  --
vim.keymap.set("n", "<C-t>", function() require("telescope.builtin").find_files( { search_dirs = {"cpp"}, no_ignore=true }) end, opts)
vim.keymap.set("n", "<C-f>", function() require("telescope.builtin").live_grep( { search_dirs = {"cpp"} }) end, opts)
vim.keymap.set("n", "<leader><space>", function() require("telescope.builtin").live_grep( { search_dirs = {"cpp"} }) end, opts)

vim.keymap.set("n", "<leader>p",
     function() require("telescope.builtin").find_files({ cwd = utils.buffer_dir(), no_ignore=true }) end, opts)
vim.keymap.set("n", "<leader>[",
     function() require("telescope.builtin").live_grep({ cwd = utils.buffer_dir(), no_ignore=true }) end, opts)

vim.keymap.set("n", "<leader>td", function()
    builtin.live_grep({
        cwd = utils.buffer_dir(),
        path_display = "hidden"
    })
end, opts)
--    ":lua require(\"telescope.builtin\").live_grep( { cwd=require(\"telescope.utils\").buffer_dir() } )<CR>", opts)

vim.keymap.set("n", "<leader>tlo", function()
    builtin.live_grep({ additional_args = { "--max-count=1" } })
end, opts)
-- keymap("n", "<leader>to", ":lua require(\"telescope.builtin\").oldfiles({ only_cwd = true })", opts)

vim.keymap.set("n", "<leader>to", function()
    builtin.oldfiles({ only_cwd = true })
end, opts)

vim.keymap.set("n", "<leader>tgs", function() require("telescope.builtin").git_status() end, opts)
vim.keymap.set("n", "<leader>tb", function() require("telescope.builtin").buffers() end, opts)


--  list app binary rules           { "bazelisk", "query", "kind(\".*_binary rule\", //cpp/...)" }, opts
--  list targets in the recent cache  { "cat", "/home/wheelert/.recent_bzl_tgts" }, opts
--

local bzl_query_picker = function(prompt_title, query_tbl, completion_fn, opts)
    opts = opts or {}

    return pickers.new(opts, {
        prompt_title = prompt_title,
        finder = finders.new_oneshot_job(
            query_tbl, opts
        ),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(bufnr, map)
            actions.select_default:replace(function()
                actions.close(bufnr)
                local target = action_state.get_selected_entry()[1]
                completion_fn(target)
            end)
            return true
        end
    })
end

local select_bazel_test = function(completion_fn, opts)
    opts = opts or {}
    local query = { "bazelisk", "query", "kind(\".*_test\", //...)" }
    local picker = bzl_query_picker("test targets", query, completion_fn, opts)
    picker:find()
end

local select_bazel_test_cwd = function(completion_fn, opts)
    opts = opts or {}
    local cwd = vim.fn.expand('%:h')
    local bazelStart,_ = string.find(cwd, "cpp")
    local sub = string.sub(cwd, bazelStart)
    local testPath = "//" .. sub ..  "/..."
    local query = { "bazelisk", "query", "kind(\".*_test\", " .. testPath .. ")" } 
    local picker = bzl_query_picker("test targets", query, completion_fn, opts)
    picker:find()
end

local select_benchmark = function(completion_fn, opts)
    opts = opts or {}
    local query = { "bazelisk", "query", "attr(tags, \"benchmark\", //...)" }
    local prompt_title = "benchmark targets"
    local picker = bzl_query_picker(prompt_title, query, completion_fn, opts)
    picker:find()
end

local select_behave_test = function(completion_fn, opts)
    opts = opts or {}
    local query = { "bazelisk", "query", "attr(tags, \"behave_test\", //...) except attr(tags, \"needs_fpga\", //...)" }
    local prompt_title = "behave test targets"
    local picker = bzl_query_picker(prompt_title, query, completion_fn, opts)
    picker:find()
end

local tmux_pane_exit_copy_mode = function(window_pane, completion_fn, opts)
    local exit_copy_mode = {
        "tmux",
        "send-keys",
        "-t",
        window_pane,
        "C-c",
    }

    -- actually not that concerned with output here.
    local empty_fn = function(_, _)
    end
    vim.fn.jobstart(exit_copy_mode, {
        stdout_buffered = false,
        stderr_buffered = false,
        on_stderr = empty_fn,
        on_stdout = empty_fn,
        on_exit = function(_, _) completion_fn(opts) end,
    })
end

local tmux_toggle_floating_term = function(completion_fn, opts)
    local toggle_floating_term = {
        "tmux", "popup", "-E", "-d", "0", "-xC", "-yC", "-w70%", "-h70%", "'tmux -u new -A -s floating'",
    }

    -- actually not that concerned with output here.
    local empty_fn = function(_, _)
    end
    vim.fn.jobstart(toggle_floating_term, {
        stdout_buffered = false,
        stderr_buffered = false,
        on_stderr = empty_fn,
        on_stdout = empty_fn,
        on_exit = function(_, _) completion_fn(opts) end,
    })
end

local tmux_pane_send_command = function(window_pane, command, completion_fn, opts)
    local send_keys_command = {
        "tmux",
        "send-keys",
        "-t",
        window_pane,
        string.format("%s", table.concat(command, " ")),
        "Enter"
    }

    -- actually not that concerned with output here.
    local empty_fn = function(_, _)
    end
    vim.fn.jobstart(send_keys_command, {
        stdout_buffered = false,
        stderr_buffered = false,
        on_stderr = empty_fn,
        on_stdout = empty_fn,
        on_exit = function(_, _) completion_fn(opts) end,
    })
end

local select_tmux_pane_in_current_window = function(completion_fn, opts)
    opts = opts or {}
    local picker = pickers.new(opts, {
        prompt_title = "select tmux pane",
        finder = finders.new_oneshot_job({ "bash", "/home/wheelert/dotfiles/get_other_tmux_panes.sh" }, opts),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(bufnr, map)
            actions.select_default:replace(function()
                actions.close(bufnr)

                -- (window).(pane) [shell] - /some/path/to process
                local entry = action_state.get_selected_entry()[1]

                local words = {}
                for word in entry:gmatch("%S+") do table.insert(words, word) end
                local window_pane = words[1]

                completion_fn(window_pane)
            end)
            return true
        end,
    })
    picker:find()
end

-- tmux panes in current window

local dropdown_theme = require("telescope.themes").get_dropdown {}

vim.keymap.set("n", "<leader>bt", function()
    select_bazel_test_cwd(function(target)
        local command = {
            "bazelisk",
            "test",
            target,
            "--remote_download_outputs=minimal",
            "--test_output=all",
            "--test_arg=--gtest_color=yes",
        }
        --select_tmux_pane_in_current_window(function(window_pane)
        vim.fn.writefile({target}, "~/.config/nvim/.last_bazel_test")
        local window_pane = "floating"
            tmux_pane_exit_copy_mode(window_pane, function(_)
                tmux_pane_send_command(window_pane, command, function(_) end, opts)
                --tmux_toggle_floating_term(function(_) end, opts)
            end, opts)
        -- end, dropdown_theme)
    end, dropdown_theme)
end, opts)

vim.keymap.set("n", "<leader>bl", function()
    local target = vim.fn.readfile("~/.config/nvim/.last_bazel_test")[1]
    local command = {
        "bazelisk",
        "test",
        target,
        "--remote_download_outputs=minimal",
        "--test_output=all",
        "--test_arg=--gtest_color=yes",
    }
    --select_tmux_pane_in_current_window(function(window_pane)
    local window_pane = "floating"
        tmux_pane_exit_copy_mode(1, function(_)
            tmux_pane_send_command(1, command, function(_) end, opts)
            --tmux_toggle_floating_term(function(_) end, opts)
        end, opts)
    -- end, dropdown_theme)
end, opts)

vim.keymap.set("n", "<leader>bo", function()
    select_bazel_test_cwd(function(target)
        local command = {
            "bazelisk",
            "test",
            target,
            "--remote_download_outputs=minimal",
            "--test_output=all",
            "--test_arg=--gtest_color=yes",
        }
        vim.fn.writefile({target}, "~/.config/nvim/.last_bazel_test")
        --select_tmux_pane_in_current_window(function(window_pane)
            tmux_pane_exit_copy_mode(1, function(_)
                tmux_pane_send_command(1, command, function(_) end, opts)
                --tmux_toggle_floating_term(function(_) end, opts)
            end, opts)
        -- end, dropdown_theme)
    end, dropdown_theme)
end, opts)

vim.keymap.set("n", "<leader>ba", function()
    select_bazel_test(function(target)
        local command = {
            "bazelisk",
            "test",
            target,
            "--remote_download_outputs=minimal",
            "--test_output=all",
            "--test_arg=--gtest_color=yes",
        }
        --select_tmux_pane_in_current_window(function(window_pane)
            tmux_pane_exit_copy_mode(1, function(_)
                tmux_pane_send_command(1, command, function(_) end, opts)
                --tmux_toggle_floating_term(function(_) end, opts)
            end, opts)
        -- end, dropdown_theme)
    end, dropdown_theme)
end, opts)

vim.keymap.set("n", "<leader>bb", function()
    local on_target = function(target)
        local command = {
            "bazelisk",
            "build",
            target,
            "--remote_download_outputs=minimal",
            "--test_output=all",
        }
        select_tmux_pane_in_current_window(function(window_pane)
            tmux_pane_exit_copy_mode(window_pane, function(_)
                tmux_pane_send_command(window_pane, command, function(_) end, opts)
            end, opts)
        end, dropdown_theme)
    end

    local query = { "bazelisk", "query", "kind(\".*_binary\", //...)" }
    local picker = bzl_query_picker("cc binary targets", query, on_target, opts)
    picker:find()
end, opts)

vim.keymap.set("n", "<leader>bm", function()
    select_benchmark(function(target)
        local command = {
            "bazelisk",
            "run",
            target,
            "--remote_download_outputs=minimal",
            "--test_output=all",
        }
        select_tmux_pane_in_current_window(function(window_pane)
            tmux_pane_exit_copy_mode(window_pane, function(_)
                tmux_pane_send_command(window_pane, command, function(_) end, opts)
            end, opts)
        end, dropdown_theme)
    end, dropdown_theme)
end, opts)

vim.keymap.set("n", "<leader>bi", function()
    select_behave_test(function(target)
        local command = {
            "bazelisk",
            "test",
            "--config=behave_test",
            target,
            "--remote_download_outputs=minimal",
            "--test_output=streamed",
            "--verbose_failures",
            "--remote_download_outputs=minimal",
            "--cache_test_results=no",
            "--test_arg=--gtest_color=yes",
        }
        select_tmux_pane_in_current_window(function(window_pane)
            tmux_pane_exit_copy_mode(window_pane, function(_)
                tmux_pane_send_command(window_pane, command, function(_) end, opts)
            end, opts)
        end, dropdown_theme)
    end, dropdown_theme)
end, opts)
