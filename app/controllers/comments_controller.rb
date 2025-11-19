class CommentsController < ApplicationController
  before_action :set_pin
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :require_comment_owner, only: [:edit, :update, :destroy]

  def create
    @comment = @pin.comments.build(comment_params)
    @comment.user_uid = current_user.uid

    if @comment.save
      redirect_to pin_path(@pin), notice: "Comment created."
    else
      redirect_to pin_path(@pin), alert: "Comment could not be saved."
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to pin_path(@pin), notice: "Comment updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to pin_path(@pin), notice: "Comment deleted."
  end

  private

  def set_pin
    @pin = Pin.find(params[:pin_id])
  end

  def set_comment
    @comment = @pin.comments.find_by(uid: params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def require_comment_owner
    unless @comment.user == current_user
      redirect_to pin_path(@pin), alert: "You can't edit this comment."
    end
  end
end
