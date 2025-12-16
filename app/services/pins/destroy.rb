module Pins
  class Destroy
    def self.call(pin:)
      pin.file.purge if pin.file.attached?
      pin.destroy
    end
  end
end
