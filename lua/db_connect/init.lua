local Job = require 'plenary.job'
local M = {}

function M:connect(opts)
    -- postgresql://[user[:password]@][host][:port][,...][/dbname][?param1=value1&...]
    local url = 'postgresql://' .. opts.username .. ':' .. opts.password .. '@' .. opts.host .. '/' .. opts.dbname
    self._connection = Job:new({
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
    self._connection:start()
    return M
end

function M:submitQuery(query)
    self._connection:send(query)
end

vim.api.nvim_create_user_command("DbConnectSubmitQuery", function(opts) M:submitQuery(opts) end, {})


function M.setup(opts)
    M:connect(opts)
end

return M
