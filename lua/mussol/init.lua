local config = require("mussol.config")
local utils = require("mussol.utils")
local ui = require("mussol.ui")
local highlighter = require("mussol.highlighter")
local M = {}
local targets = {}

-- @param opts table
function M.setup(opts)
    if opts == nil then
        targets = config.default_cfg()["targets"]
    else
        -- Validate that opts has the same structure as default config targets
        local default_targets = config.default_cfg()["targets"]
        local is_valid = true

        -- Check if opts is a table
        if type(opts) ~= "table" then
            is_valid = false
        else
            -- Check if opts has targets
            if opts.targets == nil or type(opts.targets) ~= "table" then
                is_valid = false
            else
                -- Ensure each target has the required fields (name and wt)
                for _, target in ipairs(opts.targets) do
                    if type(target) ~= "table" or
                        target.name == nil or
                        target.wt == nil then
                        is_valid = false
                        break
                    end
                end
            end
        end

        if is_valid then
            targets = opts.targets
        else
            vim.notify("Invalid configuration format. Using defaults.", vim.log.levels.WARN)
            targets = default_targets
        end
    end
end

local function grep_project()
    local sorted_results = {}

    -- Collect results with their corresponding configs
    for _, target in ipairs(targets) do
        local command = string.format('rg --vimgrep "%s"', target.name)
        local results = vim.fn.systemlist(command)
        for _, result in ipairs(results) do
            if result:find(target.name) then
                table.insert(sorted_results, { text = result, config = target })
            end
        end
    end

    table.sort(sorted_results, function(a, b) return a.config.wt > b.config.wt end)

    local content = {}
    for _, result in ipairs(sorted_results) do
        table.insert(content, result.text)
    end

    -- Display results
    local cp = ui.create_popup()
    vim.api.nvim_buf_set_lines(cp.bufnr, 0, -1, false, content)
    highlighter.highlight_results(sorted_results, targets, cp.bufnr)
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

        if action ~= nil then
            if utils.setContains(targets, action) ~= nil then
                -- grep_project()
            else
                print("Invalid action")
            end
        end
    end
    , {
        nargs = '*'
    })

return M
