class UsersController < ApplicationController
  before_action :require_login,  only: [:edit, :update, :destroy]
  before_action :set_user,       only: [:show, :edit, :update, :destroy, :tagged]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def show
    @pins = @user.pins.order(created_at: :desc)
    @reposted_pins = @user.reposted_pins.order(created_at: :desc)
    @collections = @user.collections
    @tagged_pins = @user.tagged_pins.includes(:user).order(created_at: :desc)
  end

  def tagged
    @pins = @user.tagged_pins.includes(:user).order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def create
    @user = Users::Register.call(params: user_params)

    if @user.persisted?
      session[:user_id] = @user.id
      redirect_to pins_path, notice: "Welcome to Vision, #{@user.username}!"
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit; end

  def update
    if Users::UpdateProfile.call(user: @user, params: user_params)
      redirect_to user_path(@user), notice: "Profile updated successfully!"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @user.destroy
    session.delete(:user_id)
    redirect_to root_path, notice: "Account deleted successfully."
  end

  private

  def set_user
    @user = User.find_by(id: params[:id]) || User.find_by!(uid: params[:id])
  end

  def authorize_user
    return if %w[show tagged].include?(action_name)
    redirect_to root_path, alert: "You can only edit your own profile." unless @user == current_user
  end

  def user_params
    params.require(:user).permit(
      :username,
      :email,
      :password,
      :password_confirmation,
      :avatar
    )
  end
end
