module Follows
  class Destroy < Services::BaseService
    def self.call(follower:, followed:)
      new(follower, followed).call
    end

    def initialize(follower, followed)
      super()
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
