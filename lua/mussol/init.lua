local config = require("mussol.config")
local ui = require("mussol.ui")
local highlighter = require("mussol.highlighter")
local M = {}
local targets = {}

function M.setup(user_config)
    local saved_config = {}
    if user_config == nil then
        if config.default_config_exists() then
            local loaded_config = config.load_config(config.default_config_path())
            targets = loaded_config["targets"]
            if targets == nil then
                print("No targets found in config file")
            end
        else
            local created_default_config = config.create_default_config()
            config.save_config(created_default_config)
            saved_config = config.load_config(created_default_config["path"])
            targets = saved_config["targets"]
        end
    else
        -- setup is provided TODO: validate the setup
    end
end

local function grep_project()
    local sorted_results = {}
    local cfg = config.get_tst_cfg()

    -- Collect results with their corresponding configs
    for _, target in ipairs(cfg["targets"]) do
        local command = string.format('rg --vimgrep "%s"', target.name)
        local results = vim.fn.systemlist(command)
        for _, result in ipairs(results) do
            if result:find(target.name) then
                table.insert(sorted_results, { text = result, config = target })
            end
        end
    end

    -- Sort by weight
    table.sort(sorted_results, function(a, b) return a.config.wt > b.config.wt end)

    -- Extract just the text for display
    local lines = {}
    for _, result in ipairs(sorted_results) do
        table.insert(lines, result.text)
    end

    -- Display results
    local cp = ui.create_popup()
    vim.api.nvim_buf_set_lines(cp.bufnr, 0, -1, false, lines)
    highlighter.highlight_results(sorted_results, cfg, cp.bufnr)
    vim.api.nvim_buf_set_keymap(
        cp.bufnr,
        "n",
        "<CR>",
        [[<cmd>lua require('mussol.ui').jump_to_result(vim.fn.getline('.'))<CR>]],
        {}
    )
end

vim.api.nvim_create_user_command('Mussol',
    function(opts)
        local action = opts.fargs[1]
        if action == nil then
            grep_project()
        end
        --[[
    I'm not sure if this is necessary? the user could potentiall just edit the
    config file directly.
    if action == "list" then
        -- grep_project(default_targets)
        -- TODO: Show list of tags to search for
    end

    if action == "add" then
        local tag = string.upper(opts.fargs[2])
        config.add_tag(tag)
        -- TODO: Add a new tag to search for
    end

    if action == "remove" then
        -- TODO: Remove a tag from the list
    end

    if action == "reset" then
        -- reset to default tags
    end

    if action == "edit" then
        -- open the config file
        config.edit_tags()
    end
    ]]
    end
    , {
        nargs = '*'
    })

return M
