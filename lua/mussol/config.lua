local M = {}

function M.get_default_cfg()
    local config = {
        targets = {
            { name = "TODO",  wt = 2,  fg = "orange", bg = "none" },
            { name = "FIXME", wt = 10, fg = "yellow", bg = "none" },
            { name = "BUG",   wt = 8,  fg = "red",    bg = "none" },
            { name = "NOTE",  wt = 1,  fg = "blue",   bg = "none" },
        },
    }
    return config
end

return M
