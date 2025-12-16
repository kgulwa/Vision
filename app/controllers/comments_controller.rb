class CommentsController < ApplicationController
  before_action :require_login
  before_action :set_pin
  before_action :set_comment, only: [:edit, :update, :destroy]

  def new
    @comment = @pin.comments.build(parent_id: params[:parent_id])
  end

  def create
    @comment = Comments::Create.call(
      user: current_user,
      pin: @pin,
      params: comment_params
    )

    if @comment.persisted?
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to pin_path(@pin), notice: "Comment created." }
      end
    else
      respond_to do |format|
        format.turbo_stream { head :unprocessable_entity }
        format.html do
          redirect_to pin_path(@pin),
                      alert: @comment.errors.full_messages.join(", ")
        end
      end
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to pin_path(@pin), notice: "Comment updated." }
      end
    else
      respond_to do |format|
        format.turbo_stream { head :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    Comments::Destroy.call(comment: @comment, user: current_user)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to pin_path(@pin) }
    end
  end

  private

  def set_pin
    @pin = Pin.find(params[:pin_id])
  end

  def set_comment
    @comment = @pin.comments.find_by(id: params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end
end
