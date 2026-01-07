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
M.resolved  = {}
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
    return not M.resolved[file]
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

local function get_writable_buffer()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf  = vim.api.nvim_win_get_buf(win)
        local name = vim.api.nvim_buf_get_name(buf)

        if name ~= "" and not name:match("^fugitive://") then
            return buf, win
        end
    end
end

local function diff_role(buf)
    local name = vim.api.nvim_buf_get_name(buf)

    if not name:match("^fugitive://") then
        return "LOCAL"
    end

    if name:match("//2/") then return "BASE" end
    if name:match("//3/") then return "REMOTE" end

    return "FUGITIVE"
end


local function set_diff_winbars()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.wo[win].diff then
            local role = diff_role(buf)

            vim.wo[win].winbar = string.format(
                " %%#DiffText# [%s] %%* %s",
                role,
                vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
            )
        end
    end
end

function M.refresh_picker()
    if not list_is_open() then return end
    if not vim.api.nvim_buf_is_valid(M.list_buf) then return end

    vim.api.nvim_buf_set_option(M.list_buf, "modifiable", true)
    vim.api.nvim_buf_set_lines(M.list_buf, 0, -1, false, build_list_lines())
    vim.api.nvim_buf_clear_namespace(M.list_buf, -1, 0, -1)

    for i, file in ipairs(M.conflicts) do
        local group = is_pending(file) and "MergePending" or "MergeResolved"
        vim.api.nvim_buf_add_highlight(M.list_buf, -1, group, i - 1, 1, 4)
    end

    vim.api.nvim_buf_set_option(M.list_buf, "modifiable", false)
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

    set_diff_winbars()

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
    M.resolved = {}

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
    M.resolved  = {}
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

    local buf, win = get_writable_buffer()
    if not buf then
        vim.notify("No writable file buffer found", vim.log.levels.ERROR)
        return
    end

    vim.api.nvim_set_current_win(win)

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
    vim.cmd("Git add " .. vim.fn.fnameescape(file))

    M.resolved[file] = true
    M.refresh_picker()

    vim.notify("File marked as resolved ✔", vim.log.levels.INFO)
end

function M.ignore_remote()
    if not require_session() then return end

    local file = M.conflicts[M.index]
    if not file then
        vim.notify("Invalid conflict", vim.log.levels.ERROR)
        return
    end

    local answer = vim.fn.confirm(
        "Ignore REMOTE changes and keep LOCAL version?\n\n" .. file,
        "&Yes\n&No",
        2
    )

    if answer ~= 1 then
        vim.notify("Operation cancelled", vim.log.levels.INFO)
        return
    end

    vim.cmd("Git checkout --ours -- " .. vim.fn.fnameescape(file))
    vim.cmd("Git add -- " .. vim.fn.fnameescape(file))

    M.resolved[file] = true
    M.refresh_picker()

    vim.notify("Remote ignored (kept LOCAL) ✔", vim.log.levels.INFO)
end


-----------------------------------------------------------------------
-- Picker UI
-----------------------------------------------------------------------
function M.pick()
    M.refresh_picker()

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

function M.take_base_current_file()
    if not require_session() then return end

    local buf = vim.api.nvim_get_current_buf()
    local file = vim.api.nvim_buf_get_name(buf)

    if file == "" or file:match("^fugitive://") then
        vim.notify("Not a writable worktree file", vim.log.levels.ERROR)
        return
    end

    local answer = vim.fn.confirm(
        "Apply BASE to ALL conflicts in this file?\n\n" .. file,
        "&Yes\n&No",
        2
    )

    if answer ~= 1 then
        vim.notify("Operation cancelled", vim.log.levels.INFO)
        return
    end

    -- garante início do arquivo
    vim.api.nvim_win_set_cursor(0, { 1, 0 })

    while has_conflict_markers(buf) do
        vim.cmd("diffget //2")
        vim.cmd("normal ]c")
    end

    vim.cmd("write")
    vim.cmd("Git add -- " .. vim.fn.fnameescape(file))

    M.resolved[file] = true
    M.refresh_picker()

    vim.notify("All conflicts in file resolved using BASE ✔", vim.log.levels.INFO)
end

function M.take_remote_current_file()
    if not require_session() then return end

    local buf = vim.api.nvim_get_current_buf()
    local file = vim.api.nvim_buf_get_name(buf)

    if file == "" or file:match("^fugitive://") then
        vim.notify("Not a writable worktree file", vim.log.levels.ERROR)
        return
    end

    local answer = vim.fn.confirm(
        "Apply REMOTE to ALL conflicts in this file?\n\n" .. file,
        "&Yes\n&No",
        2
    )

    if answer ~= 1 then
        vim.notify("Operation cancelled", vim.log.levels.INFO)
        return
    end

    vim.api.nvim_win_set_cursor(0, { 1, 0 })

    while has_conflict_markers(buf) do
        vim.cmd("diffget //3")
        vim.cmd("normal ]c")
    end

    vim.cmd("write")
    vim.cmd("Git add -- " .. vim.fn.fnameescape(file))

    M.resolved[file] = true
    M.refresh_picker()

    vim.notify("All conflicts in file resolved using REMOTE ✔", vim.log.levels.INFO)
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

vim.keymap.set("n", "<leader>mb", ":diffget //2<CR>", vim.tbl_extend("force", opts, {
    desc = "Merge: take LOCAL",
}))

vim.keymap.set("n", "<leader>mr", ":diffget //3<CR>", vim.tbl_extend("force", opts, {
    desc = "Merge: take REMOTE",
}))

vim.keymap.set("n", "<leader>ma", M.pick, vim.tbl_extend("force", opts, {
    desc = "Merge: pick conflict",
}))

vim.keymap.set("n", "<leader>mi", M.ignore_remote, vim.tbl_extend("force", opts, {
    desc = "Merge: ignore REMOTE (keep LOCAL)",
}))

vim.keymap.set("n", "<leader>mcb", M.take_base_current_file, vim.tbl_extend("force", opts, {
    desc = "Merge: take BASE for current file",
}))

vim.keymap.set("n", "<leader>mcr", M.take_remote_current_file, vim.tbl_extend("force", opts, {
    desc = "Merge: take REMOTE for current file",
}))


return M
