-- merge_conflicts.lua

-----------------------------------------------------------------------
-- Color highlights
-----------------------------------------------------------------------
vim.api.nvim_set_hl(0, "MergeResolved", { fg = "#98c379" }) -- green
vim.api.nvim_set_hl(0, "MergePending",  { fg = "#e06c75" }) -- red

-----------------------------------------------------------------------
-- Internal state
-----------------------------------------------------------------------
local M = {}

M.active   = false
M.conflicts = {}
M.index     = 0
M.list_buf  = nil
M.list_win  = nil

-----------------------------------------------------------------------
-- Utils
-----------------------------------------------------------------------
local function require_session()
    if not M.active then
        vim.notify("No active merge session", vim.log.levels.WARN)
        return false
    end
    return true
end

local function list_is_open()
    return M.list_win and vim.api.nvim_win_is_valid(M.list_win)
end

local function is_pending(file)
    for _, f in ipairs(M.conflicts) do
        if f == file then
            return true
        end
    end
    return false
end

local function shorten_path(path, max_len)
    max_len = max_len or 40
    if #path <= max_len then
        return path
    end

    local sep = package.config:sub(1, 1)
    local parts = vim.split(path, sep)

    if #parts <= 2 then
        return path:sub(1, max_len - 3) .. "..."
    end

    return parts[1] .. sep .. "..." .. sep .. parts[#parts]
end

local function build_list_lines()
    local lines = {}

    for _, file in ipairs(M.conflicts) do
        local icon = is_pending(file) and "✖" or "✔"
        table.insert(lines, string.format(" %s  %s", icon, shorten_path(file)))
    end

    return lines
end

local function cleanup_diff()
    vim.cmd("windo if &diff | diffoff | endif")
    vim.cmd("only")

    local current = vim.api.nvim_get_current_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end
end

local function close_all_file_buffers()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf)
           and vim.api.nvim_buf_is_loaded(buf)
           and vim.bo[buf].buftype == "" then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end
end

-----------------------------------------------------------------------
-- Core logic
-----------------------------------------------------------------------
local function open_current()
    local file = M.conflicts[M.index]
    if not file then
        vim.notify("Invalid conflict index", vim.log.levels.ERROR)
        return
    end

    cleanup_diff()
    vim.cmd("edit " .. file)
    vim.cmd("Gvdiffsplit!")

    vim.notify(
        string.format("Conflict %d/%d: %s", M.index, #M.conflicts, file),
        vim.log.levels.INFO
    )
end

-----------------------------------------------------------------------
-- Session control
-----------------------------------------------------------------------
function M.start()
    if M.active then
        vim.notify("Merge session already active", vim.log.levels.INFO)
        return
    end

    M.conflicts = vim.fn.systemlist("git diff --name-only --diff-filter=U")

    if #M.conflicts == 0 then
        vim.notify("No conflicts found 🎉", vim.log.levels.INFO)
        return
    end

    M.active = true
    M.index  = 1

    vim.notify(
        string.format("Merge session started (%d conflicts)", #M.conflicts),
        vim.log.levels.INFO
    )

    open_current()
end

function M.finish()
    if not require_session() then return end

    if list_is_open() then
        vim.api.nvim_win_close(M.list_win, true)
    end

    cleanup_diff()
    close_all_file_buffers()

    M.active    = false
    M.conflicts = {}
    M.index     = 0
    M.list_buf  = nil
    M.list_win  = nil

    vim.notify("Merge session finished", vim.log.levels.INFO)
end

-----------------------------------------------------------------------
-- Navigation
-----------------------------------------------------------------------
function M.next()
    if not require_session() then return end

    if M.index >= #M.conflicts then
        vim.notify("Already at last conflict", vim.log.levels.INFO)
        return
    end

    M.index = M.index + 1
    open_current()
end

function M.prev()
    if not require_session() then return end

    if M.index <= 1 then
        vim.notify("Already at first conflict", vim.log.levels.INFO)
        return
    end

    M.index = M.index - 1
    open_current()
end

-----------------------------------------------------------------------
-- Resolve helpers
-----------------------------------------------------------------------
local function has_conflict_markers(bufnr)
    for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr or 0, 0, -1, false)) do
        if line:match("^<<<<<<<") or line:match("^=======") or line:match("^>>>>>>>") then
            return true
        end
    end
    return false
end

function M.write_and_add()
    if not require_session() then return end

    if has_conflict_markers(0) then
        vim.notify("Unresolved conflicts still exist", vim.log.levels.ERROR)
        vim.cmd("normal ]c")
        return
    end

    local file = vim.api.nvim_buf_get_name(0)
    local answer = vim.fn.confirm("Mark this file as resolved?", "&Yes\n&No", 2)

    if answer ~= 1 then
        vim.notify("Operation cancelled", vim.log.levels.INFO)
        return
    end

    vim.cmd("write")
    vim.cmd("Git add " .. file)

    vim.notify("File marked as resolved ✔", vim.log.levels.INFO)
end

-----------------------------------------------------------------------
-- Picker UI
-----------------------------------------------------------------------
function M.pick()
    if not require_session() then return end

    if list_is_open() then
        vim.api.nvim_win_close(M.list_win, true)
        M.list_win, M.list_buf = nil, nil
        return
    end

    local width  = math.floor(vim.o.columns * 0.6)
    local height = math.min(#M.conflicts + 2, math.floor(vim.o.lines * 0.6))
    local row    = math.floor((vim.o.lines - height) / 2)
    local col    = math.floor((vim.o.columns - width) / 2)

    local buf = vim.api.nvim_create_buf(false, true)
    M.list_buf = buf

    vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, build_list_lines())

    -- make buffer read-only
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_buf_set_option(buf, "readonly", true)

    for i, file in ipairs(M.conflicts) do
        local group = is_pending(file) and "MergePending" or "MergeResolved"
        vim.api.nvim_buf_add_highlight(buf, -1, group, i - 1, 1, 4)
    end

    M.list_win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        style = "minimal",
        border = "rounded",
        width = width,
        height = height,
        row = row,
        col = col,
    })

    vim.api.nvim_win_set_option(M.list_win, "cursorline", true)
    vim.api.nvim_win_set_cursor(M.list_win, { M.index, 0 })

    vim.keymap.set("n", "<CR>", function()
        M.index = vim.api.nvim_win_get_cursor(0)[1]
        vim.api.nvim_win_close(M.list_win, true)
        M.list_win, M.list_buf = nil, nil
        open_current()
    end, { buffer = buf })

    vim.keymap.set("n", "q", function()
        vim.api.nvim_win_close(M.list_win, true)
        M.list_win, M.list_buf = nil, nil
    end, { buffer = buf })
end

-----------------------------------------------------------------------
-- Keybindings
-----------------------------------------------------------------------
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>ms", M.start, vim.tbl_extend("force", opts, {
    desc = "Merge: start session",
}))

vim.keymap.set("n", "<leader>mf", M.finish, vim.tbl_extend("force", opts, {
    desc = "Merge: finish session",
}))

vim.keymap.set("n", "<leader>mn", M.next, vim.tbl_extend("force", opts, {
    desc = "Merge: next conflict",
}))

vim.keymap.set("n", "<leader>mp", M.prev, vim.tbl_extend("force", opts, {
    desc = "Merge: previous conflict",
}))

vim.keymap.set("n", "<leader>mw", M.write_and_add, vim.tbl_extend("force", opts, {
    desc = "Merge: write & mark resolved",
}))

vim.keymap.set("n", "<leader>ml", ":diffget //2<CR>", vim.tbl_extend("force", opts, {
    desc = "Merge: take LOCAL",
}))

vim.keymap.set("n", "<leader>mr", ":diffget //3<CR>", vim.tbl_extend("force", opts, {
    desc = "Merge: take REMOTE",
}))

vim.keymap.set("n", "<leader>mb", ":diffget //1<CR>", vim.tbl_extend("force", opts, {
    desc = "Merge: take BASE",
}))

vim.keymap.set("n", "<leader>ma", M.pick, vim.tbl_extend("force", opts, {
    desc = "Merge: pick conflict",
}))

return M
