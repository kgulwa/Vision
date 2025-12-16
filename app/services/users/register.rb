module Users
  class Register
    def self.call(params:)
      new(params).call
    end

    def initialize(params)
      @params = params
    end

    def call
      user = User.new(params)
      return user unless user.save

      user
    end

    private

    attr_reader :params
  end
end
