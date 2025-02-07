local M = {}

function M.addToSet(set, key)
    set[key] = true
end

function M.removeFromSet(set, key)
    set[key] = nil
end

function M.setContains(set, key)
    return set[key] ~= nil
end

return M
