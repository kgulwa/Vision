class InsightsController < ApplicationController
  before_action :require_login

  def show
    insights = Insights::Overview.call(user: current_user)

    @views                    = insights[:views] || []
    @total_views              = insights[:total_views] || 0
    @views_per_day             = insights[:views_per_day] || {}
    @average_watch_time        = insights[:average_watch_time] || 0
    @total_screen_time_minutes = insights[:total_screen_time_minutes] || 0
    @video_pins                = insights[:video_pins] || []
    @top_pins                  = insights[:top_pins] || []
  end
end
