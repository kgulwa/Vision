class CollectionsController < ApplicationController
  before_action :require_login
  before_action :set_collection, only: [:show, :destroy, :edit, :update, :remove_pin]

  def create
    @collection = Collections::Create.call(
      user: current_user,
      name: params[:name],
      pin_id: params[:pin_id]
    )

    redirect_to collection_path(@collection), notice: "Collection created!"
  end

  def show
    @saved_pins = @collection.saved_pins.includes(:pin)
  end

  def edit
  end

  def update
    if Collections::Update.call(
         collection: @collection,
         name: params[:collection][:name]
       )
      redirect_to collection_path(@collection), notice: "Collection renamed!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def saved
    @collections = current_user.collections.includes(:saved_pins, :pins)
  end

  def destroy
    @collection.destroy
    redirect_to saved_path, notice: "Collection deleted."
  end

  def remove_pin
    Collections::RemovePin.call(
      collection: @collection,
      saved_pin_id: params[:saved_pin_id]
    )

    redirect_to collection_path(@collection), notice: "Pin removed."
  end

  private

  def set_collection
    collection_id = params[:id] || params[:collection_id]
    @collection = current_user.collections.find_by(id: collection_id)

    redirect_to saved_path, alert: "Collection not found" unless @collection
  end
end
