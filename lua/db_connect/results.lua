local M = {}

local BUF_NAME = "db_connect://results"

function M.append_line(opts)
    if M.results_buf == nil then
        vim.cmd("vsp " .. BUF_NAME)

        M.results_buf = vim.api.nvim_get_current_buf()
        vim.bo[M.results_buf].swapfile = false
        vim.bo[M.results_buf].buftype = 'nofile'
    end

    M._write_line(opts.line)
end

function M.clear()
    vim.bo[M.results_buf].modifiable = true
    vim.api.nvim_buf_set_lines(M.results_buf, 0, -1, false, { '' })
    vim.bo[M.results_buf].modifiable = false
end

function M._write_line(line)
    vim.bo[M.results_buf].modifiable = true
    vim.api.nvim_buf_set_lines(M.results_buf, -1, -1, false, { line })
    vim.bo[M.results_buf].modifiable = false
end

return M
