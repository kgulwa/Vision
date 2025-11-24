class CommentsController < ApplicationController
  before_action :require_login
  before_action :set_pin
  before_action :set_comment, only: [:edit, :update, :destroy]

  def new
    @comment = @pin.comments.new(parent_id: params[:parent_id])
  end

  def create
    @comment = @pin.comments.build(comment_params)
    @comment.user_id = current_user.id
    @comment.parent_id = params[:parent_id] if params[:parent_id]

    if @comment.save
      redirect_to pin_path(@pin.id), notice: "Comment created."
    else
      redirect_to pin_path(@pin.id), alert: @comment.errors.full_messages.join(", ")
    end
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to pin_path(@pin.id), notice: "Comment updated."
    else
      redirect_to pin_path(@pin.id), alert: @comment.errors.full_messages.join(", ")
    end
  end

  def destroy
    @comment.destroy if @comment.user_id == current_user.id
    redirect_to pin_path(@pin.id)
  end

  private

  def set_pin
    @pin = Pin.find_by(id: params[:pin_id] || params[:id])
    redirect_to pins_path, alert: "Pin not found" unless @pin
  end

  def set_comment
    @comment = @pin.comments.find_by(id: params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end
end
