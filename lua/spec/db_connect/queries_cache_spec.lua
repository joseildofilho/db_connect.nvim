describe('tests the cache for queries', function()
    it('should add 1 query only when we do it manually', function()
        local cache = require 'db_connect.queries_cache'
        cache.add_query('select * from anything;')

        assert.equals(#cache.query_queue, 1)
    end)

    it('should add 1 query only when we do it manually', function()
        local cache = require 'db_connect.queries_cache'
        cache.add_query('select * from anything;')

        assert.equals(#cache.query_queue, 1)
    end)
end)
