module Follows
  class Destroy
    def self.call(follower:, followed:)
      new(follower, followed).call
    end

    def initialize(follower, followed)
      @follower = follower
      @followed = followed
    end

    def call
      follower.unfollow(followed)
      followed.reload
      followed
    end

    private

    attr_reader :follower, :followed
  end
end
