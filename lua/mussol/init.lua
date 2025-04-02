local config = require("mussol.config")
local utils = require("mussol.utils")
local ui = require("mussol.ui")
local highlighter = require("mussol.highlighter")

local M = {}
local targets = {}

---Validate configuration options
---@param opts table|nil Configuration options
---@return boolean Whether the configuration is valid
local function validate_config(opts)
    if type(opts) ~= "table" then
        return false
    end

    if opts.targets == nil or type(opts.targets) ~= "table" then
        return false
    end

    for _, target in ipairs(opts.targets) do
        if type(target) ~= "table" or
            target.name == nil or
            target.wt == nil then
            return false
        end
    end

    return true
end

---Search for targets in the project using ripgrep
---@return table Sorted results with their configurations
local function search_targets()
    local results = {}

    for _, target in ipairs(targets) do
        local command = string.format('rg --vimgrep "%s"', target.name)
        local grep_results = vim.fn.systemlist(command)

        for _, result in ipairs(grep_results) do
            if result:find(target.name) then
                table.insert(results, { text = result, config = target })
            end
        end
    end

    return results
end

---Sort results by weight
---@param results table Results to sort
---@return table Sorted results
local function sort_results(results)
    table.sort(results, function(a, b)
        return a.config.wt > b.config.wt
    end)

    return results
end

---Extract text content from results with line numbers
---@param results table Results with configurations
---@return table Array of text lines with line numbers
local function extract_content(results)
    local content = {}
    for i, result in ipairs(results) do
        table.insert(content, string.format("%d. %s", i, result.text))
    end
    return content
end

---Display search results in a popup window with line numbers
---@param results table Sorted results with configurations
local function display_results(results)
    local content = extract_content(results)

    -- Create popup window
    local cp = ui.create_popup()

    -- Set content
    vim.api.nvim_buf_set_lines(cp.bufnr, 0, -1, false, content)

    -- Apply highlighting
    highlighter.highlight_results(results, targets, cp.bufnr)

    -- Set keymaps
    vim.api.nvim_buf_set_keymap(
        cp.bufnr,
        "n",
        "<CR>",
        [[<cmd>lua require('mussol.ui').jump_to_result(vim.fn.getline('.'):match("^%d+%. (.+)$"))<CR>]],
        { noremap = true, silent = true }
    )
end

---Search for targets in the project and display results
local function grep_project()
    local results = search_targets()
    local sorted_results = sort_results(results)
    display_results(sorted_results)
end

---Setup mussol with the given options
---@param opts table|nil Configuration options
function M.setup(opts)
    local default_targets = config.default_cfg()["targets"]

    if opts == nil then
        targets = default_targets
        return
    end

    if validate_config(opts) then
        targets = opts.targets
    else
        vim.notify("Invalid configuration format. Using defaults.", vim.log.levels.WARN)
        targets = default_targets
    end
end

-- Register user command
vim.api.nvim_create_user_command('Mussol',
    function(opts)
        local action = opts.fargs[1]

        if action == nil then
            grep_project()
            return
        end

        if utils.setContains(targets, action) then
            -- TODO: Implement action-specific search
            -- Currently commented out in original code
        else
            vim.notify("Invalid action: " .. action, vim.log.levels.ERROR)
        end
    end,
    {
        nargs = '*',
        desc = "Search for TODO-style comments in your project"
    }
)

return M
