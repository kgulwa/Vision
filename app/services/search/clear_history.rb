module Search
    class ClearHistory
        def self.call(user:)
            user.search_histories.destroy_all
        end
    end
end
