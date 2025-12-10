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

    @comments = @pin.comments
                    .includes(:user, :replies)
                    .select do |comment|
                      comment.user.present? &&
                      (comment.parent.nil? || comment.parent.user.present?)
                    end
  end

  def new
    @pin = Pin.new
  end

  def create
    Rails.logger.info " PARAMS: #{params.inspect}"

    # current_user.pins.build assigns user_uid automatically
    @pin = current_user.pins.build(pin_params)

    if @pin.save
      create_pin_tags(@pin)
      redirect_to pin_path(@pin), notice: "Pin posted successfully!"
    else
      Rails.logger.info "❌ PIN SAVE FAILED: #{@pin.errors.full_messages}"
      flash.now[:alert] = "Failed to post pin."
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @pin.update(pin_params)
      redirect_to pin_path(@pin), notice: "Pin updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pin.file.purge if @pin.file.attached?
    @pin.destroy
    redirect_to pins_path, notice: "Pin deleted successfully!"
  end

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

  private

  def set_pin
    @pin = Pin.find_by(id: params[:id])
    redirect_to pins_path, alert: "Pin not found" unless @pin
  end

  # Supports images + videos + custom video thumbnail
  def pin_params
    params.require(:pin).permit(
      :title,
      :description,
      :file,          # unified uploader
      :thumbnail   # custom thumbnail
    )
  end

  def authorize_user
    redirect_to pins_path, alert: "You can only edit your own pins." unless @pin.user == current_user
  end

 
  def create_pin_tags(pin)
    return unless params[:pin][:tagged_user_ids].present?

    # Remove old tags before adding new ones
    pin.pin_tags.destroy_all

    params[:pin][:tagged_user_ids]
      .reject(&:blank?)
      .each do |user_uid|

      # Find user using UID instead of ID
      tagged_user = User.find_by(uid: user_uid)
      next unless tagged_user   # Skip invalid UIDs to avoid crashes

      PinTag.create!(
        pin: pin,
        tagged_user_id: tagged_user.id,
        tagged_by_id: current_user.id
      )

      #  Notify tagged user
      Notification.create!(
        user_id: tagged_user.id,
        actor_id: current_user.id,
        notifiable: pin,
        action: "tagged_you"
      )
    end
  end
end
