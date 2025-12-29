module Follows
  class Create < Services::BaseService
    def self.call(follower:, followed:)
      new(follower, followed).call
    end

    def initialize(follower, followed)
      super()
      @follower = follower
      @followed = followed
    end

    def call
      follower.follow(followed)
      followed.reload
      notify_followed_user
      followed
    end

    private

    attr_reader :follower, :followed

    def notify_followed_user
      return if follower.id == followed.id

      Notification.create!(
        user: followed,
        actor: follower,
        action: "started following you",
        notifiable: followed,
        read: false
      )
    end
  end
end
