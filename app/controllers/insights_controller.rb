class InsightsController < ApplicationController
  before_action :require_login

  def show
    @user = current_user

    insights = Insights::Overview.call(user: @user)

    @views                    = insights[:views]
    @total_views              = insights[:total_views]
    @views_per_day             = insights[:views_per_day]
    @average_watch_time        = insights[:average_watch_time]
    @total_screen_time_minutes = insights[:total_screen_time_minutes]
    @video_pins                = insights[:video_pins]
    @top_pins                  = insights[:top_pins]
  end
end
