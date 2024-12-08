describe('tests the cache for queries', function()
    it('should add 1 query only when we do it manually', function()
        local cache = require 'db_connect.queries_cache':new()
        local choosed_query = 'select * from anything;'
        cache:add_query(choosed_query)

        assert.equals(#cache:get_cached_queries(), 1)
        assert.equals(cache:get_cached_queries()[1], choosed_query)
    end)

    it('should add 2 queries, but the cache limit is 1', function()
        local cache = require 'db_connect.queries_cache':new({
            cache_limit = 1
        })

        local second_query = 'select * from somewhere;'
        cache:add_query('select * from anything;')
        cache:add_query(second_query)

        assert.equals(cache:get_cached_queries()[2], second_query)
        assert.equals(cache:get_cached_queries()[1], nil)
    end)
end)
