local M = {}

local cache = {}

function M:new(ex_config)
    local config = ex_config or {}

    local o = {}
    setmetatable(o, cache)
    o.__index = cache

    cache.query_queue = { head = 0, tail = 0 }
    cache.cache_limit = config.cache_limit or 10

    return cache
end

function cache:add_query(query)
    cache.query_queue.tail = cache.query_queue.tail + 1
    local tail = self.query_queue.tail
    cache.query_queue[tail] = query;

    local head = self.query_queue.head
    local limit = self.cache_limit
    if tail - head > limit then
        local new_head = head + 1
        self.query_queue[new_head] = nil
        self.query_queue.head = new_head
    end
end

function cache:get_cached_queries()
    return self.query_queue
end

return M
