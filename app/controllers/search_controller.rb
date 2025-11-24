class SearchController < ApplicationController
  before_action :require_login

  def users
    @query = params[:query]

    @users = if @query.present?
               User.where("username ILIKE ?", "%#{@query}%")
             else
               User.none
             end
  end
end
