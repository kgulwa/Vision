module Pins
  class Search
    def self.call(query:)
      return Pin.none unless query.present?

      Pin
        .where("title ILIKE ? OR description ILIKE ?", "%#{query}%", "%#{query}%")
        .includes(:user)
        .from_existing_users
        .recent
    end
  end
end
