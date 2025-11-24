class CommentsController < ApplicationController
  before_action :require_login
  before_action :set_pin
  before_action :set_comment, only: [:edit, :update, :destroy]

  def new
    @comment = @pin.comments.new(parent_uid: params[:parent_id])
  end

  def create
    @comment = @pin.comments.build(comment_params)
    @comment.user_uid = current_user.uid
    @comment.parent_uid = params[:parent_id] if params[:parent_id]

    if @comment.save
      redirect_to pin_path(@pin.uid), notice: "Comment created."
    else
      redirect_to pin_path(@pin.uid), alert: @comment.errors.full_messages.join(", ")
    end
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to pin_path(@pin.uid), notice: "Comment updated."
    else
      redirect_to pin_path(@pin.uid), alert: @comment.errors.full_messages.join(", ")
    end
  end

  def destroy
    @comment.destroy if @comment.user_uid == current_user.uid
    redirect_to pin_path(@pin.uid)
  end

  private

  def set_pin
    
    uid = params[:pin_uid]

    @pin = Pin.find_by(uid: uid)
    redirect_to pins_path, alert: "Pin not found" if @pin.nil?
  end

  def set_comment
    @comment = @pin.comments.find_by(uid: params[:uid])
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_uid)
  end
end
