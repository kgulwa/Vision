class SearchController < ApplicationController
  before_action :require_login

  def users
    @query = params[:query]

    @users = Search::Users.call(
      user: current_user,
      query: @query
    )

    @history = current_user
                 .search_histories
                 .order(updated_at: :desc)
                 .limit(10)
  end

  def clear_history
    Search::ClearHistory.call(user: current_user)
    redirect_to user_search_path, notice: "Search history cleared."
  end
end
