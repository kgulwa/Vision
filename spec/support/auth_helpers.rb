module AuthHelpers
  def log_in_as(user)
    
    session[:user_id] = user.uid

    
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user)
      .and_return(user)
  end
end
