class PinsController < ApplicationController
  before_action :require_login, except: [:index, :show, :search]
  before_action :set_pin, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def index
    @pins = Pin.recent.includes(:user)
  end

  def show
    @comments = @pin.comments.recent.includes(:user)
  end

  def new
    @pin = Pin.new
  end

  def create
    @pin = current_user.pins.build(pin_params)
    if @pin.save
      redirect_to pins_path, notice: "Pin posted successfully!"
    else
      flash.now[:alert] = "Failed to post pin. Please check the form."
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @pin.update(pin_params)
      redirect_to @pin, notice: "Pin updated successfully!"
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
                 .recent.includes(:user)
            else
              Pin.none
            end
  end

  private

  def set_pin
    @pin = Pin.find(params[:id])
  end

  def pin_params
    params.require(:pin).permit(:title, :description, :image)
  end

  def authorize_user
    redirect_to pins_path, alert: "You can only edit your own pins." unless @pin.user == current_user
  end
end
