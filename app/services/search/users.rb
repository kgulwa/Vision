module Search
    class Users
        def self.call(user:, query:)
            new(user, query).call
        end


        def initialize(user, query)
            @user = user
            @query = query&.downcase
        end 

        def call 
            save_history if query.present?
            search_results
        end 

        private

        attr_reader :user, :query

        def save_history
            existing = user.search_histories.find_by(query: query) 
            
            if existing 
                existing.touch
            else
                user.search_histories.create(query: query)
            end
        end


        def search_results
            return User.none unless query.present?


            User
            .with_attached_avatar
            .where("username ILIKE ?", "%#{query}%")
        end
    end
end

