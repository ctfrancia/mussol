local M = {}
local default_config_path = vim.fn.stdpath("config") .. "mussol-config.json"

function M.default_config_exists()
    local file = io.open(default_config_path, "r")
    if file then
        file:close()
        return true
    else
        return false
    end
end

function M.default_config_path()
    return default_config_path
end

function M.load_config(path_to_config)
    if not path_to_config then
        print("No path provided.")
        return nil
    end

    local file = io.open(path_to_config, "r")
    if not file then return nil end

    local jsonData = file:read("*all")
    file:close()
    local settings, err = vim.fn.json_decode(jsonData)
    if err then
        print("Error decoding JSON: " .. err)
        return nil
    else
        return settings
    end
end

function M.save_config(config)
    if not config then
        print("No config provided.")
        return
    end

    local jsonData = vim.fn.json_encode(config)
    local file = io.open(config["path"], "w")
    if file then
        file:write(jsonData)
        file:close()
    else
        print("Error opening file for writing.")
    end
end

function M.create_default_config()
    local default_config = {
        name = "",
        path = default_config_path,
        targets = { "TODO", "FIXME", "BUG", "NOTE" },
        highlight = {
            TODO  = { wt = 3, fg = "orange", bg = "none" },
            FIXME = { wt = 1, fg = "yellow", bg = "none" },
            BUG   = { wt = 2, fg = "red", bg = "none" },
            NOTE  = { wt = 4, fg = "blue", bg = "none" },
        },
    }

    return default_config
end

return M
