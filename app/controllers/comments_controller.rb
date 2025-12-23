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
      success_response("Comment created.")
    else
      error_response(@comment.errors.full_messages.join(", "))
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      success_response("Comment updated.")
    else
      respond_with_unprocessable_entity
    end
  end

  def destroy
    Comments::Destroy.call(comment: @comment, user: current_user)
    success_response
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

  # ---- Response helpers ----

  def success_response(message = nil)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to pin_path(@pin), notice: message }
    end
  end

  def error_response(message)
    respond_to do |format|
      format.turbo_stream { head :unprocessable_entity }
      format.html { redirect_to pin_path(@pin), alert: message }
    end
  end

  def respond_with_unprocessable_entity
    respond_to do |format|
      format.turbo_stream { head :unprocessable_entity }
      format.html { render :edit, status: :unprocessable_entity }
    end
  end
end
