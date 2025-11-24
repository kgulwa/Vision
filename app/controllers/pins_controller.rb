class PinsController < ApplicationController
  before_action :require_login, except: [:index, :show, :search]
  before_action :set_pin, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def index
    @pins = Pin.includes(:user).from_existing_users.recent
  end

  def show
    unless @pin.user.present?
      redirect_to pins_path, alert: "Pin not found"
      return
    end

    @comments = @pin.comments.includes(:user, :replies).select do |comment|
      comment.user.present? &&
        (comment.parent.nil? || comment.parent.user.present?)
    end
  end

  def new
    @pin = Pin.new
  end

  def create
    @pin = current_user.pins.build(pin_params)
    if @pin.save
      redirect_to pin_path(@pin.uid), notice: "Pin posted successfully!"
    else
      flash.now[:alert] = "Failed to post pin."
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @pin.update(pin_params)
      redirect_to pin_path(@pin.uid), notice: "Pin updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pin.destroy
    redirect_to pins_path, notice: "Pin deleted successfully!"
  end

  def search
    @query = params[:query]
    @pins = if @query.present?
              Pin.where("title LIKE ? OR description LIKE ?", "%#{@query}%", "%#{@query}%")
                 .includes(:user)
                 .from_existing_users
                 .recent
            else
              Pin.none
            end
  end

  private

  def set_pin
    uid = params[:uid] || params[:pin_uid] || params[:id]
    @pin = Pin.find_by(uid: uid)
    redirect_to pins_path, alert: "Pin not found" if @pin.nil?
  end

  def pin_params
    params.require(:pin).permit(:title, :description, :image)
  end

  def authorize_user
    redirect_to pins_path, alert: "You can only edit your own pins." unless @pin.user == current_user
  end
end
