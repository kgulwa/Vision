class VideoViewsController < ApplicationController
  before_action :require_login
  before_action :set_video_view, only: [:update]

  def update
    safe_params = video_view_params

    @video_view.update(
      ended_at: Time.current,
      duration_seconds: safe_params[:duration_seconds]
    )

    render json: { status: "ok" }
  end

  private

  def set_video_view
    @video_view = VideoView.find(params[:id])
  end

  def video_view_params
    params.require(:video_view).permit(:duration_seconds)
  end
end
