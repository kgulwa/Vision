class PinsController < ApplicationController
  before_action :require_login, except: [:index, :show, :search]
  before_action :set_pin, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  # -------------------------
  # INDEX
  # -------------------------
  def index
    @pins = Pin.includes(:user).from_existing_users.recent
  end

  # -------------------------
  # SHOW
  # -------------------------
  def show
    # If the pin somehow has no user, avoid errors
    unless @pin.user.present?
      redirect_to pins_path, alert: "Pin not found"
      return
    end

    # Only show comments with valid users & valid parents
    @comments = @pin.comments
                    .includes(:user, :replies)
                    .select do |comment|
                      comment.user.present? &&
                      (comment.parent.nil? || comment.parent.user.present?)
                    end
  end

  # -------------------------
  # NEW
  # -------------------------
  def new
    @pin = Pin.new
  end

  # -------------------------
  # CREATE
  # -------------------------
  def create
    @pin = current_user.pins.build(pin_params)

    if @pin.save
      redirect_to pin_path(@pin), notice: "Pin posted successfully!"
    else
      flash.now[:alert] = "Failed to post pin."
      render :new, status: :unprocessable_entity
    end
  end

  # -------------------------
  # EDIT
  # -------------------------
  def edit
  end

  # -------------------------
  # UPDATE
  # -------------------------
  def update
    if @pin.update(pin_params)
      redirect_to pin_path(@pin), notice: "Pin updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # -------------------------
  # DESTROY
  # -------------------------
  def destroy
    # SAFE PURGE — only purge if an image exists
    @pin.image.purge if @pin.image.attached?

    @pin.destroy
    redirect_to pins_path, notice: "Pin deleted successfully!"
  end

  # -------------------------
  # SEARCH
  # -------------------------
  def search
    @query = params[:query]

    @pins =
      if @query.present?
        Pin.where("title ILIKE ? OR description ILIKE ?", "%#{@query}%", "%#{@query}%")
           .includes(:user)
           .from_existing_users
           .recent
      else
        Pin.none
      end
  end

  # -------------------------
  # PRIVATE
  # -------------------------
  private

  def set_pin
    # Now that uid is gone, we lookup by actual PK id
    @pin = Pin.find_by(id: params[:id])
    redirect_to pins_path, alert: "Pin not found" unless @pin
  end

  def pin_params
    params.require(:pin).permit(:title, :description, :image)
  end

  def authorize_user
    redirect_to pins_path, alert: "You can only edit your own pins." unless @pin.user == current_user
  end
end
