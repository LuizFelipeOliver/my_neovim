local function open_notes_popup(notes_file)
    local notes_dir = vim.fn.fnamemodify(notes_file, ":h")

    if vim.fn.isdirectory(notes_dir) == 0 then
        vim.fn.mkdir(notes_dir, "p")
    end

    if vim.fn.filereadable(notes_file) == 0 then
        vim.fn.writefile({
            "# Notes",
            "",
            "## Todo",
            "- [ ] ",
            "",
        }, notes_file)
    end

    local buf = vim.fn.bufadd(notes_file)
    vim.fn.bufload(buf)

    local width = math.floor(vim.o.columns * 0.9)
    local height = math.floor(vim.o.lines * 0.8)

    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })

    vim.wo[win].wrap = true
    vim.wo[win].number = false
    vim.wo[win].relativenumber = false
    vim.bo[buf].filetype = "markdown"

    vim.keymap.set("n", "q", function()
        if vim.bo[buf].modified then
            vim.api.nvim_buf_call(buf, function()
                vim.cmd("silent write")
            end)
        end

        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end, {
        buffer = buf,
        silent = true,
        desc = "Salvar e fechar notes popup",
    })
end

vim.keymap.set("n", "<leader>tn", function()
    local notes_file = vim.fn.getcwd() .. "/.notes/notes.md"
    open_notes_popup(notes_file)
end, { desc = "Abrir notes.md do projeto" })

vim.keymap.set("n", "<leader>tl", function()
    local notes_file = vim.fn.stdpath("config") .. "/.notes/note.md"
    open_notes_popup(notes_file)
end, { desc = "Abrir note.md global" })
