class PinsController < ApplicationController
  before_action :set_pin, only: %i[ show edit update destroy ]

  # GET /pins or /pins.json
  def index
    @pins = Pin.all
  end

  # GET /pins/1 or /pins/1.json
  def show
  end

  # GET /pins/new
  def new
    @pin = Pin.new
  end

  # GET /pins/1/edit
  def edit
  end

  # POST /pins or /pins.json
  def create
    @pin = Pin.new(pin_params)

    respond_to do |format|
      if @pin.save
        format.html { redirect_to @pin, notice: "Pin was successfully created." }
        format.json { render :show, status: :created, location: @pin }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pin.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @pin.update(pin_params)
        format.html { redirect_to @pin, notice: "Pin was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @pin }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pin.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @pin.destroy!

    respond_to do |format|
      format.html { redirect_to pins_path, notice: "Pin was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def search
    @query = params[:query]
    @pins = if @query.present?
              Pin.where("title LIKE ? OR description LIKE ?", "%#{@query}%", "%#{@query}%")
            else
              Pin.none
            end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pin
      @pin = Pin.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def pin_params
      params.expect(pin: [ :title, :description ])
    end
end
