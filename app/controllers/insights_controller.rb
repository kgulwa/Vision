class InsightsController < ApplicationController
  before_action :require_login

  def show
    @user = current_user  

    # Load all video views for this user’s pins
    @views = VideoView
      .joins(:pin)
      .where(pins: { user_uid: @user.uid })

    # Total Views
    @total_views = @views.count

    # Grouped by day
    @views_per_day = @views.group_by_day(:started_at).count

    # Average watch duration
    @average_watch_time = @views.average(:duration_seconds) || 0

    # Total watch time (seconds)
    @total_time = @views.sum(:duration_seconds) || 0

    # Convert to minutes
    @total_screen_time_minutes = (@total_time / 60.0).round(1)

    # Number of video pins
    @video_pins = @user.pins.select { |p| p.file&.video? } || []

    # Most watched videos (safe SQL)
    @top_pins = @views
      .group(:pin_id)
      .order(Arel.sql("COUNT(*) DESC"))
      .limit(5)
      .count
  end
end
