local json = require("dkjson")
local M = {}


function M.default_config_exists()
    local file = io.open(M.default_config_path(), "r")
    if file then
        file:close()
        return true
    else
        return false
    end
end

function M.default_config_path()
    local default_config_path = "mussol.json"
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
    local settings, pos, err = json.decode(jsonData, 1, nil)
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

    local jsonData = json.encode(config, { indent = true })
    local file = io.open(config["path"], "w")
    if file then
        file:write(jsonData)
        file:close()
    else
        print("Error opening file for writing.")
    end
end

function M.create_default_config()
    -- local config_path = vim.fn.stdpath("config") .. "/mussol.json" UNCOMMENT FOR Live
    local config_path = "mussol.json"
    local default_config = {
        name = "default",
        path = config_path,
        targets = { "TODO", "FIXME", "BUG", "NOTE" },
        highlight = {
            TODO  = { fg = "orange", bg = "none" },
            FIXME = { fg = "yellow", bg = "none" },
            BUG   = { fg = "red", bg = "none" },
            NOTE  = { fg = "blue", bg = "none" },
        },
    }
    return default_config
end

return M
