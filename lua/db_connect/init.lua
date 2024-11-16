local fidget = require 'fidget'
local Job = require 'plenary.job'
local ResultsDisplay = require 'db_connect.results'

local M = {}

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
                ResultsDisplay.append_line({
                    line = data
                })
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

function M.submit_query(query)
    M._connection:send(query .. '\n')
end

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
