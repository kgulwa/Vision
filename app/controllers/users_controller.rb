class UsersController < ApplicationController
  before_action :require_login, only: [:edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def show
    @pins = @user.pins.recent
    @reposted_pins = @user.reposted_pins.recent
    @collections = @user.collections
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_uid] = @user.uid
      redirect_to root_path, notice: "Account created successfully!"
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user.uid), notice: "Profile updated successfully!"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @user.destroy
    session.delete(:user_uid)
    redirect_to root_path, notice: "Account deleted successfully."
  end

  def check_email
    email = params[:email]&.downcase
    render json: { available: email.present? && !User.exists?(email: email) }
  end

  def check_username
    username = params[:username]
    render json: { available: username.present? && !User.exists?(username: username) }
  end

  def check_username_exists
    username = params[:username]
    render json: { exists: username.present? && User.exists?(username: username) }
  end

  def check_password
    user = User.find_by(username: params[:username])
    render json: { valid: user&.authenticate(params[:password]).present? }
  end

  private

  def set_user
    uid = params[:id] || params[:user_id] || params[:uid]
    @user = User.find_by(uid: uid)
    redirect_to root_path, alert: "User not found." unless @user
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def authorize_user
    redirect_to root_path, alert: "You can only edit your own profile." unless @user == current_user
  end
end
