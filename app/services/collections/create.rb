module Collections
  class Create
    def self.call(user:, name:, pin_id: nil)
      new(user, name, pin_id).call
    end

    def initialize(user, name, pin_id)
      @user = user
      @name = name
      @pin_id = pin_id
    end

    def call
      collection = user.collections.create!(name: name)
      add_pin_to_collection(collection) if pin_id.present?
      collection
    end

    private

    attr_reader :user, :name, :pin_id

    def add_pin_to_collection(collection)
      SavedPin.create!(
        user_id: user.id,
        pin_id: pin_id,
        collection_id: collection.id
      )
    end
  end
end
