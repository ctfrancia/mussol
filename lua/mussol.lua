local M = {}
local default_targets = { "TODO", "FIXME", "BUG", "NOTE" }
local settings = require('settings')

local function grep_project(targets)
    -- settings.setup()
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

    vim.fn.setqflist({}, 'r', { title = 'Grep results', lines = output })

    -- Open the quickfix list
    vim.cmd('copen')
end

vim.api.nvim_create_user_command('Mussol', 
    function(opts)
        local targets = { "TODO", "FIXME", "BUG", "NOTE" }
        local action = opts.fargs[1]
        print(action)
        if action == nil then
            grep_project(default_targets)
        end
        if action == "list" then
            -- grep_project(default_targets)
            -- TODO: Show list of tags to search for
        end

        if action == "add" then
            -- TODO: Add a new tag to search for
        end

        if action == "remove" then
            -- TODO: Remove a tag from the list
        end

        if action == "reset" then
            -- reset to default tags
        end
        -- print(opts.fargs[1])
        -- grep_project(opts.fargs[1])
    end
, {
    -- nargs = 1
})

return M

--[[
local function create_buffer()
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_name(buf, "*scratch*")
  vim.api.nvim_set_option_value("filetype", "lua", { buf = buf })
  return buf
end


local function main()
    local buf = create_buffer()
    print("Hello from our plugin!!!!!!!!")
    grep_project("hi")
end

local function setup()
  local augroup = vim.api.nvim_create_augroup("MUSSOL", { clear = true })
  vim.api.nvim_create_autocmd("VimEnter",
    { group = augroup, desc = "Set a fennel scratch buffer on load", once = true, callback = main })
end

return { setup = setup }
]]
