local M = {}
-- local default_targets = { "TODO", "FIXME", "BUG", "NOTE" }
local json = require("dkjson")

function M.add_tag(tag)
    tag = string.upper(tag)
    print("Adding a tag", tag)
end

function M.edit_tags()
    print("Editing tags")
    local buf = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_open_win(buf, false, {
        relative = "win",
        split = "vertical",
        width = 40,
        height = 10,
        row = 10,
        col = 10,
    })
end

function M.save_tags()
    print("Saving tags")
end

function M.load_tags(filename)
    print("Loading tags", filename)
    local file = io.open(filename, "r")
    if not file then return nil end
    --[[
    if file then
        local jsonData = file:read("*all")
        file:close()
        local settings, pos, err = json.decode(jsonData, 1, nil)
        if err then
            print("Error decoding JSON: " .. err)
            return nil
        else
            return settings
        end
    else
        create_config()
        print("Error opening file for reading.")
        return nil
    end
    ]]
end

function M.create_config(name)
    local default_config = {
        config_name = "mussol.json",
        -- config_path = vim.fn.stdpath("config") .. "/mussol.json", TODO
        targets = { "TODO", "FIXME", "BUG", "NOTE" },
        highlight = {
            TODO  = { fg = "red", bg = "none" },
            FIXME = { fg = "yellow", bg = "none" },
            BUG   = { fg = "red", bg = "none" },
            NOTE  = { fg = "blue", bg = "none" },
        },
    }
    local jsonData = json.encode(default_config, { indent = true })
    local file = io.open(name, "w")
    if file then
        file:write(jsonData)
        file:close()
    else
        print("Error opening file for writing.")
    end
end

return M
