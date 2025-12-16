module Pins
  class Create
    def self.call(user:, params:, tagged_user_ids:)
      new(user, params, tagged_user_ids).call
    end

    def initialize(user, params, tagged_user_ids)
      @user = user
      @params = params
      @tagged_user_ids = tagged_user_ids
    end

    def call
      pin = user.pins.build(params)
      return pin unless pin.save

      tag_users(pin)
      pin
    end

    private

    attr_reader :user, :params, :tagged_user_ids

    def tag_users(pin)
      return unless tagged_user_ids.present?

      pin.pin_tags.destroy_all

      tagged_user_ids.reject(&:blank?).each do |uid|
        tagged_user = User.find_by(uid: uid)
        next unless tagged_user

        PinTag.create!(
          pin: pin,
          tagged_user_id: tagged_user.id,
          tagged_by_id: user.id
        )

        Notification.create!(
          user: tagged_user,
          actor: user,
          notifiable: pin,
          action: "tagged_you"
        )
      end
    end
  end
end
