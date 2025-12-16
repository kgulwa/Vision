module Mentions
  class Search
    def self.call(query:)
      new(query).call
    end

    def initialize(query)
      @query = query.to_s.downcase
    end

    def call
      users.map { |u| serialize_user(u) }
    end

    private

    attr_reader :query

    def users
      User
        .where("LOWER(username) LIKE ?", "%#{query}%")
        .limit(10)
    end

    def serialize_user(user)
      {
        id: user.respond_to?(:uid) ? user.uid : user.id,
        username: user.username,
        avatar: avatar_url(user)
      }
    end

    def avatar_url(user)
      return unless user.avatar.attached?

      Rails.application.routes.url_helpers.url_for(user.avatar)
    end
  end
end
