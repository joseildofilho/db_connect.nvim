local fidget = require 'fidget'
local Job = require 'plenary.job'
local M = {}

function M.connect(urlObj)
    urlObj = urlObj or {}
    urlObj.url = urlObj.url or "postgresql://postgres:postgres@localhost:5460/swp-cash-out-service"
    urlObj.name = urlObj.name or "default"
    -- postgresql://[user[:password]@][host][:port][,...][/dbname][?param1=value1&...]
    M._connection = Job:new({
        command = 'psql',
        args = { urlObj.url },
        on_stdout = function(_, data)
            vim.schedule(function()
                local results_buf = nil
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    local buf_name = vim.api.nvim_buf_get_name(buf)
                    print(buf_name)
                    if buf_name == 'db_connect://results' then
                        results_buf = buf
                        break
                    end
                end
                if results_buf == nil then
                    local current_buf = vim.api.nvim_get_current_buf()

                    vim.cmd [[vsp db_connect://results]]
                    results_buf = vim.api.nvim_get_current_buf()

                    vim.api.nvim_set_current_buf(current_buf)
                end

                vim.api.nvim_buf_set_lines(results_buf, 0, -1, false, data)
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

vim.api.nvim_create_user_command("DbConnectSubmitQuery", function(opts) M.submitQuery(opts) end, {})

function M.setup(opts)
    if opts.connections then
        if table.getn(opts.connections) ~= 1 then
            print("Only one connection is supported")
            return
        end
        M.connect(opts.connections[1]())
    end
end

return M
