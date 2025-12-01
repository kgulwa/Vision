class UsersController < ApplicationController
  before_action :require_login,  only: [:edit, :update, :destroy]
  before_action :set_user,       only: [:show, :edit, :update, :destroy, :tagged]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def show
    @pins = @user.pins.order(created_at: :desc)
    @reposted_pins = @user.reposted_pins.order(created_at: :desc)
    @collections = @user.collections
  end

  # ✅ Instagram-style TAGGED POSTS page
  def tagged
    @pins = @user.tagged_pins
                 .includes(:user)
                 .from_existing_users
                 .recent
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to pins_path, notice: "Welcome to Vision, #{@user.username}!"
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    cleaned = user_params.dup

    # If password blank, do not update password fields
    if cleaned[:password].blank?
      cleaned.delete(:password)
      cleaned.delete(:password_confirmation)
    end

    if @user.update(cleaned)
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
    # We use find with UUID or ID
    @user = User.find(params[:id])
  end

  def authorize_user
    return if action_name == "show" || action_name == "tagged"

    unless @user == current_user
      redirect_to root_path, alert: "You can only edit your own profile."
    end
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
