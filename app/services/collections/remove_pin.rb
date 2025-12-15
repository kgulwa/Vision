module Collections
  class RemovePin
    def self.call(collection:, saved_pin_id:)
      new(collection, saved_pin_id).call
    end

    def initialize(collection, saved_pin_id)
      @collection = collection
      @saved_pin_id = saved_pin_id
    end

    def call
      saved_pin = collection.saved_pins.find_by(id: saved_pin_id)
      saved_pin&.destroy
    end

    private

    attr_reader :collection, :saved_pin_id
  end
end
