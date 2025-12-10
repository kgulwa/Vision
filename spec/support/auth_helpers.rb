module AuthHelpers
  def log_in_as(user)
    # Store UID because your app uses UID as session key
    session[:user_id] = user.uid

    # Ensure current_user returns the right user in tests
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user)
      .and_return(user)
  end
end
