local M = {}
local default_targets = { "TODO", "FIXME", "BUG", "NOTE" }
-- Lua function to search a project using Ripgrep (rg)
local function grep_project(targets)
    print("---- ln", table.getn(targets))
  -- Use Ripgrep (rg) to search for the pattern in the project
  local command = string.format('rg --vimgrep %s', tostring(pattern))
  
  -- Execute the command and capture the output
  local output = vim.fn.systemlist(command)
  
  -- Check if the command was successful (output is not empty)
  if #output == 0 then
    print("No results found")
    return
  end
  
  -- Set the quickfix list to show the results
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
        -- print(opts.fargs[1])
        -- grep_project(opts.fargs[1])
    end
, {
    -- nargs = 1
})
--[[
vim.api.nvim_create_user_command(
    'Mussol',
    function(opts)
        print(opts.args)
        grep_project(opts)
    end,
    {
        nargs = 1,
        complete = function(ArgLead, CmdLine, CursorPos)
            return vim.fn.getCompletion(ArgLead, "file")
        end
    }
)
]]


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
