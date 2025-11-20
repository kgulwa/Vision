class CommentsController < ApplicationController
  before_action :set_pin
  before_action :set_comment, only: [:edit, :update, :destroy]

  def new
    @comment = @pin.comments.new(parent_id: params[:parent_id])
  end

  def create
    @comment = @pin.comments.build(comment_params)
    @comment.user_uid = current_user.uid
    @comment.parent_id = params[:parent_id] if params[:parent_id]

    if @comment.save
      redirect_to @pin, notice: "Comment was successfully created."
    else
      redirect_to @pin, alert: "Unable to create comment: #{@comment.errors.full_messages.join(', ')}"
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to @pin, notice: "Comment was successfully updated."
    else
      redirect_to @pin, alert: "Unable to update comment: #{@comment.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @comment.destroy
    redirect_to @pin, notice: "Comment was successfully deleted."
  end

  private

  def set_pin
    @pin = Pin.find(params[:pin_id])
  end

  def set_comment
    @comment = @pin.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end
end
