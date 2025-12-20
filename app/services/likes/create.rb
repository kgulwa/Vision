module Likes
  class Create
    def self.call(user:, pin:)
      new(user, pin).call
    end

    def initialize(user, pin)
      @user = user
      @pin = pin
    end

    def call
      user.like(pin)
      notify_pin_owner
      notify_tagged_users
    end

    private

    attr_reader :user, :pin, :name


    def notify_pin_owner
      return if pin.user.uid == user.uid

      Notification.create!(
        user: pin.user,
        actor: user,
        action: "liked your post",
        notifiable: pin,
        read: false
      )
    end

    def notify_tagged_users
      pin.tagged_users.each do |tagged|
        next if tagged.id == user.id

        Notification.create!(
          user: tagged,
          actor: user,
          action: "liked a post you're tagged in",
          notifiable: pin,
          read: false
        )
      end
    end
  end
end
