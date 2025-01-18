local M = {}
local targets = {}

function M.add(tag)
    tag = string.upper(tag)
    print("Adding a target", tag)
end

function M.edit()
    print("edit target")
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

function M.load(filename)
    if not filename then
        print("No filename provided.")
        return nil
    end
    local file = io.open(filename, "r")
    if not file then return nil end

    local jsonData = file:read("*all")
    file:close()
    local settings, pos, err = json.decode(jsonData, 1, nil)
    if err then
        print("Error decoding JSON: " .. err)
        return nil
    else
        return settings
    end
end

