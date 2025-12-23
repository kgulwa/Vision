class UserProfile
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def pins
    user.pins.order(created_at: :desc)
  end

  def reposted_pins
    user.reposted_pins.order(created_at: :desc)
  end

  def collections
    user.collections
  end

  def tagged_pins
    user.tagged_pins.includes(:user).order(created_at: :desc)
  end
end
