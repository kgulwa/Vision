class PinsController < ApplicationController
  before_action :require_login, except: [:index, :show, :search]
  before_action :set_pin, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def index
    @pins = Pin.includes(:user).from_existing_users.recent
  end

  def show
    redirect_to pins_path, alert: "Pin not found" and return unless @pin.user.present?

    if logged_in?
      Pins::TrackVideoView.call(user: current_user, pin: @pin)
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
    @pin = Pins::Create.call(
      user: current_user,
      params: pin_params,
      tagged_user_ids: params.dig(:pin, :tagged_user_ids)
    )

    if @pin.persisted?
      redirect_to pin_path(@pin), notice: "Pin posted successfully!"
    else
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
    Pins::Destroy.call(pin: @pin)
    redirect_to pins_path, notice: "Pin deleted successfully!"
  end

  def search
    @query = params[:query]
    @pins = Pins::Search.call(query: @query)
  end

  private

  def set_pin
    @pin = Pin.find_by(id: params[:id])
    redirect_to pins_path, alert: "Pin not found" unless @pin
  end

  def pin_params
    params.require(:pin).permit(:title, :description, :file, :thumbnail)
  end

  def authorize_user
    redirect_to pins_path, alert: "You can only edit your own pins." unless @pin.user == current_user
  end
end
