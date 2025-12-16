module Sessions
  class Authenticate
    def self.call(username:, password:)
      new(username, password).call
    end

    def initialize(username, password)
      @username = username
      @password = password
    end

    def call
      user = User.find_by(username: username)
      return nil unless user&.authenticate(password)

      user
    end

    private

    attr_reader :username, :password
  end
end
