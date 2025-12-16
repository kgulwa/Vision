class VideoViewsController < ApplicationController
  before_action :require_login

  def update
    video_view = VideoView.find(params[:id])

    VideoViews::Update.call(
      video_view: video_view,
      duration_seconds: video_view_params[:duration_seconds]
    )

    render json: { status: "ok" }
  end

  private

  def video_view_params
    params.require(:video_view).permit(:duration_seconds)
  end
end
