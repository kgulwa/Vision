class MentionsController < ApplicationController
  before_action :require_login

  def index
    results = Mentions::Search.call(query: params[:q])
    render json: results
  end
end
