local M = {}

-- Function to setup highlights for each target
function M.setup_highlights(config)
    for _, target in ipairs(config.targets) do
        local highlight_group = "Mussol" .. target.name
        -- Create highlight group for each target
        vim.api.nvim_command(string.format(
            "highlight %s guifg=%s guibg=%s",
            highlight_group,
            target.fg,
            target.bg == "none" and "NONE" or target.bg
        ))
    end
end

-- Function to highlight results
function M.highlight_results(sorted_results, config, bufnr)
    -- Setup highlight groups
    M.setup_highlights(config)

    -- Highlight each line based on its corresponding config
    for i, result in ipairs(sorted_results) do
        local highlight_group = "Mussol" .. result.config.name
        vim.api.nvim_buf_add_highlight(
            bufnr,
            -1,    -- namespace ID (-1 for a new namespace)
            highlight_group,
            i - 1, -- 0-based line number
            0,     -- start column (entire line)
            -1     -- end column (-1 means whole line)
        )
    end
end

return M
