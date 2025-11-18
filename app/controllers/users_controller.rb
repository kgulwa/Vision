class UsersController < ApplicationController
  before_action :require_login, only: [:edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def show
    @pins = @user.pins.recent
    @reposted_pins = @user.reposted_pins.recent
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Account created successfully!"
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Profile updated successfully!"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @user.destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Account deleted successfully."
  end

  # AJAX endpoint to check email availability (for signup)
  def check_email
    email = params[:email]&.downcase
    available = email.present? && !User.exists?(email: email)
    render json: { available: available }
  end

  # AJAX endpoint to check username availability (for signup)
  def check_username
    username = params[:username]
    available = username.present? && !User.exists?(username: username)
    render json: { available: available }
  end

  # AJAX endpoint to check if username exists (for login)
  def check_username_exists
    username = params[:username]
    exists = username.present? && User.exists?(username: username)
    render json: { exists: exists }
  end

  # AJAX endpoint to check password validity (for login)
  def check_password
    username = params[:username]
    password = params[:password]
    
    user = User.find_by(username: username)
    valid = user && user.authenticate(password)
    
    render json: { valid: !!valid }
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def authorize_user
    unless @user == current_user
      redirect_to root_path, alert: "You can only edit your own profile."
    end
  end
end
