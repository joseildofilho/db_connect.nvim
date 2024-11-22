local M = {}

M.query_queue = { head = 1, tail = 2 }

function M.add_query(query)
    local first = M.query_queue.head

    M.query_queue.head = M.query_queue.head + 1

    M.query_queue[first] = query;
end

function M.get_cached_queries()
    return M.query_queue
end

return M
