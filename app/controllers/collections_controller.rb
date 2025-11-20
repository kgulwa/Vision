class CollectionsController < ApplicationController
  before_action :require_login

  def create
    # Create the collection for the current user
    @collection = current_user.collections.create!(
      name: params[:name]
    )

    # If user was saving a pin, store it inside this new collection
    if params[:pin_id].present?
      SavedPin.create!(
        user_uid: current_user.uid,
        pin_id: params[:pin_id],
        collection_id: @collection.id
      )
    end

    redirect_to collection_path(@collection), notice: "Saved successfully!"
  end

  def show
    # Load only the current user's collection
    @collection = current_user.collections.find(params[:id])
  end

  private

  def require_login
    redirect_to login_path unless logged_in?
  end
end
