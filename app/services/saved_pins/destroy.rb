module SavedPins
  class Destroy
    def self.call(saved_pin_id:)
      new(saved_pin_id).call
    end

    def initialize(saved_pin_id)
      @saved_pin_id = saved_pin_id
    end

    def call
      saved_pin = SavedPin.find_by(id: saved_pin_id)
      pin = saved_pin&.pin
      saved_pin&.destroy
      pin
    end

    private

    attr_reader :saved_pin_id
  end
end
