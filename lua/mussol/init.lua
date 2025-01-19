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

local function grep_project(targets)
    local output = {}
    for i, target in ipairs(targets) do
        local command = string.format('rg --vimgrep "%s"', target)
        local res = vim.fn.systemlist(command)
        if vim.v.shell_error ~= 0 then
            print("Error running command for target:", target)
        else
            for _, line in ipairs(res) do
                table.insert(output, line)
            end
        end
    end

    if #output == 0 then
        print("No results found")
        return
    end

    ui.toggle_results(output) -- TODO: Rename this function to what it actually does
end

vim.api.nvim_create_user_command('Mussol', 
function(opts)
    local action = opts.fargs[1]
    if action == nil then
        grep_project(targets)
    end
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
end
, {
    nargs = '*'
})

return M
