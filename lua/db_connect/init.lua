local pgmoon = require"pgmoon"
local M = {}

function M.connect()
    local pg = pgmoon.new({
        host = "localhost",
        port = "5460",
        database = "swp-cash-out-service",
        user = "postgres",
        password = "postgres",
    })
    assert(pg:connect())
end

vim.api.nvim_create_user_command("DBConnect", function(opts)

    print(opts)
    M.connect()

end, {})

function M.setup(opts)
    print(opts)
end

print("olá mundo")

return M
