class SearchController < ApplicationController
  before_action :require_login

  def users
    @query = params[:query]

    # Save search history if query is present
    if @query.present?
      existing = current_user.search_histories.find_by(query: @query.downcase)

      if existing
        existing.touch # move it to the top by updating timestamp
      else
        current_user.search_histories.create(query: @query.downcase)
      end
    end

    # Search results
    @users = if @query.present?
               User.where("username ILIKE ?", "%#{@query}%")
             else
               User.none
             end

    # User's recent search history
    @history = current_user.search_histories.order(updated_at: :desc).limit(10)
  end

  def clear_history
    current_user.search_histories.destroy_all
    redirect_to user_search_path, notice: "Search history cleared."
  end
end
