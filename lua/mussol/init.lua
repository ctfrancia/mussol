local config = require("mussol.config")
local ui = require("mussol.ui")
local M = {}
local targets = {}

function M.setup(user_config)
    local saved_config = {}
    if user_config == nil then
        if config.default_config_exists() then
            local loaded_config = config.load_config(config.default_config_path())
            targets = loaded_config["targets"]
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
    local cfg = config.load_config(config.default_config_path())

    for _, target in ipairs(cfg["targets"]) do

        local command = string.format('rg --vimgrep "%s"', target)
        local results = vim.fn.systemlist(command)

        for _, result in ipairs(results) do

            if result:find(target) then
                table.insert(sorted_results, { text = result, config = cfg["highlight"][target] })
            end
        end
    end

    table.sort(sorted_results, function(a, b) return a.config.wt > b.config.wt end)

    local lines = {}
    for _, result in ipairs(sorted_results) do
        table.insert(lines, result.text)
    end

    ui.toggle_results(lines, sorted_results) -- TODO: Rename this function to what it actually does
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
