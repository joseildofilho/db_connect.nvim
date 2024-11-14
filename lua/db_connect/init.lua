local Job = require 'plenary.job'
local M = {}

function M.connect()
    -- postgresql://[user[:password]@][host][:port][,...][/dbname][?param1=value1&...]
    local username = 'postgres'
    local password = 'postgres'
    local host = 'localhost:5460'
    local dbname = 'swp-cash-out-service'
    local url = 'postgresql://' .. username .. ':' .. password .. '@' .. host .. '/' .. dbname
    print(url)
    M.connection = Job:new({
        command = 'psql',
        args = { url },
        on_stdout = function(_, data)
            print("stdout", data)
        end,
        on_stderr = function(_, data)
            print("stderr", data)
        end,
        on_exit = function(_, data)
            print("exit", data)
        end,
        interactive = true
    })
    M.connection:start()
    return M
end

vim.api.nvim_create_user_command("DBConnect", function(opts)
    print(opts)
    M.connect()
end, {})

function M.setup(opts)
    print(opts)
end

return M
