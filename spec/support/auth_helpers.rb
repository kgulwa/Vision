module AuthHelpers
  # For controller specs
  def controller_log_in(user)
    session[:user_id] = user.uid
  end

  # For request specs
  def request_log_in(user)
    post login_path,
         params: { username: user.username, password: user.password }
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :controller
  config.include AuthHelpers, type: :request
end
