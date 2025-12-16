module Insights
  class Overview
    def self.call(user:)
      new(user).call
    end

    def initialize(user)
      @user = user
    end

    def call
      {
        views: views,
        total_views: total_views,
        views_per_day: views_per_day,
        average_watch_time: average_watch_time,
        total_screen_time_minutes: total_screen_time_minutes,
        video_pins: video_pins,
        top_pins: top_pins
      }
    end

    private

    attr_reader :user

    def views
      @views ||= VideoView
        .joins(:pin)
        .where(pins: { user_uid: user.uid })
    end

    def total_views
      views.count
    end

    def views_per_day
      views.group_by_day(:started_at).count
    end

    def average_watch_time
      views.average(:duration_seconds) || 0
    end

    def total_screen_time_minutes
      (views.sum(:duration_seconds).to_f / 60).round(1)
    end

    def video_pins
      user.pins.select { |p| p.file&.video? }
    end

    def top_pins
      views
        .group(:pin_id)
        .order(Arel.sql("COUNT(*) DESC"))
        .limit(5)
        .count
    end
  end
end
