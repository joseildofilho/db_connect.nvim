local M = {}

local cache = {}

cache.query_queue = { head = 1, tail = 2 }

function M:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return cache
end

function cache:add_query(query)
    local first = M.query_queue.head

    cache.query_queue.head = M.query_queue.head + 1

    cache.query_queue[first] = query;
end

function cache:get_cached_queries()
    return M.query_queue
end

return M
