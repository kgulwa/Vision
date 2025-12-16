module Users
  class UpdateProfile
    def self.call(user:, params:)
      new(user, params).call
    end

    def initialize(user, params)
      @user = user
      @params = params.dup
    end

    def call
      cleanup_password_fields
      user.update(params)
    end

    private

    attr_reader :user, :params

    def cleanup_password_fields
      if params[:password].blank?
        params.delete(:password)
        params.delete(:password_confirmation)
      end
    end
  end
end
