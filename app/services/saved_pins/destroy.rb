module SavedPins
  class Destroy
    def self.call(saved_pin_id:)
      saved_pin = SavedPin.find_by(id: saved_pin_id)
      pin = saved_pin.pin  
      saved_pin.destroy
      pin
    end
  end
end
