local M = {}
local popup = require("plenary.popup")

Mussol_win_id = nil
Mussol_bufh = nil

local function close_popup()
    vim.api.nvim_win_close(Mussol_win_id, true)

    Mussol_win_id = nil
    Mussol_bufh = nil
end

local function create_popup()
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.6)
    local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
    local bufnr = vim.api.nvim_create_buf(false, false)

    local Mussol_win_id, win = popup.create(bufnr, {
        title = "Results",
        highlight = "MussolWindow",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
    })

    vim.api.nvim_win_set_option(
        win.border.win_id,
        "winhl",
        "Normal:MussolBorder"
    )
    vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>bd!<CR>", { noremap = true, silent = true })

    return {
        bufnr = bufnr,
        win_id = Mussol_win_id,
    }
end

function M.toggle_results(content, buffers)
    if Mussol_win_id ~= nil and vim.api.nvim_win_is_valid(Mussol_win_id) then
        close_popup()
        return
    end

    local win_info = create_popup()
    print(#content)

    Mussol_win_id = win_info.win_id
    Mussol_bufh = win_info.bufnr

    vim.api.nvim_win_set_option(Mussol_win_id, "number", true)
    vim.api.nvim_buf_set_name(Mussol_bufh, "mussol-menu")
    vim.api.nvim_buf_set_lines(Mussol_bufh, 0, #content, false, content)
    vim.api.nvim_buf_set_option(Mussol_bufh, "filetype", "mussol")
    vim.api.nvim_buf_set_option(Mussol_bufh, "buftype", "acwrite")
    vim.api.nvim_buf_set_option(Mussol_bufh, "bufhidden", "delete")
    vim.api.nvim_buf_set_keymap(
        Mussol_bufh,
        "n",
        "<CR>",
        [[<cmd>lua require('ui').jump_to_result(vim.fn.getline('.'))<CR>]],
        {}
    )
end

local function get_or_create_buffer(filename)
    local buf_exists = vim.fn.bufexists(filename) ~= 0
    if buf_exists then
        return vim.fn.bufnr(filename)
    end

    return vim.fn.bufadd(filename)
end

function M.jump_to_result(line)
    close_popup()
    local filename, lnum, col = line:match("^(.-):(%d+):(%d+):")
    if filename and lnum and col then
        local buf_id = get_or_create_buffer(filename)
        local set_row = not vim.api.nvim_buf_is_loaded(buf_id)

        local old_bufnr = vim.api.nvim_get_current_buf()

        vim.api.nvim_set_current_buf(buf_id)
        vim.api.nvim_buf_set_option(buf_id, "buflisted", true)

        if set_row then
             vim.api.nvim_win_set_cursor(0, { tonumber(lnum), tonumber(col) })
        end
    end
end



return M
