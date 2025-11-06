class CommentsController < ApplicationController
  before_action :require_login
  before_action :set_pin

  def create
    @comment = @pin.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @pin, notice: "Comment added successfully!"
    else
      redirect_to @pin, alert: "Failed to add comment."
    end
  end

  def destroy
    @comment = @pin.comments.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      redirect_to @pin, notice: "Comment deleted successfully!"
    else
      redirect_to @pin, alert: "You can only delete your own comments."
    end
  end

  private

  def set_pin
    @pin = Pin.find(params[:pin_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def require_login
    unless logged_in?
      redirect_to login_path, alert: "You must be logged in to comment."
    end
  end
end