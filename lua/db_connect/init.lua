local fidget = require 'fidget'
local Job = require 'plenary.job'
local M = {}

local BUF_NAME = "db_connect://results"

function M.connect(urlObj)
    urlObj = urlObj or {}
    urlObj.url = urlObj.url or "postgresql://postgres:postgres@localhost:5432/postgres"
    urlObj.name = urlObj.name or "default"
    -- postgresql://[user[:password]@][host][:port][,...][/dbname][?param1=value1&...]
    M._connection = Job:new({
        command = 'psql',
        args = { urlObj.url },
        on_stdout = function(_, data)
            vim.schedule(function()
                if M.results_buf == nil then
                    vim.cmd("vsp " .. BUF_NAME)

                    M.results_buf = vim.api.nvim_get_current_buf()
                    vim.bo[M.results_buf].swapfile = false
                    vim.bo[M.results_buf].buftype = 'nofile'
                end

                vim.bo[M.results_buf].modifiable = true
                vim.api.nvim_buf_set_lines(M.results_buf, -1, -1, false, { data })
                vim.bo[M.results_buf].modifiable = false
            end)
        end,
        on_stderr = function(_, data)
            print("stderr", data)
        end,
        on_exit = function(_, data)
            print("exit", data)
        end,
        interactive = true
    })
    fidget.notify("Connecting to " .. urlObj.name, vim.log.levels.INFO)
    M._connection:start()
    fidget.notify("Connected to " .. urlObj.name, vim.log.levels.INFO)
    return M
end

function M.submitQuery(query)
    M._connection:send(query .. '\n')
end

vim.api.nvim_create_user_command("DbConnectSubmitQuery", M.submitQuery, {})

function M.setup(opts)
    if opts.connections then
        if table.getn(opts.connections) > 1 then
            print("Only one connection is supported")
            return
        end
        M.connect(opts.connections[1]())
    else
        M.connect({})
    end
end

return M
