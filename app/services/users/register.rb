module Users
  class Register
    def self.call(user_params)
      new(user_params).call
    end

    def initialize(user_params)
      @user_params = user_params
    end

    def call
      user = User.create!(@user_params)

      Users::EmailVerificationService.new(user).call
      UserMailer.email_verification(user).deliver_now

      user
    end
  end
end
