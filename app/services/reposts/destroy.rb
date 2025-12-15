module Reposts
  class Destroy
    def self.call(user:, pin:)
      new(user, pin).call
    end

    def initialize(user, pin)
      @user = user
      @pin = pin
    end

    def call
      user.reposts.where(pin: pin).destroy_all
    end

    private

    attr_reader :user, :pin
  end
end
