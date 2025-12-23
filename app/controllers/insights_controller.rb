class InsightsController < ApplicationController
  before_action :require_login

  def show
    @insights = Insights::Overview.call(user: current_user)
  end
end
