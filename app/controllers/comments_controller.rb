class CommentsController < ApplicationController
  before_action :require_login
  before_action :set_pin
  before_action :set_comment, only: [:edit, :destroy]

  # Prevent Rails 7.1 from raising errors about callbacks missing actions
  skip_action_callback :set_comment, only: [:update] rescue nil

  def create
    @comment = @pin.comments.build(comment_params)
    @comment.user = current_user
    @comment.parent_id = params[:parent_id] if params[:parent_id]

    if @comment.save
      # NOTIFICATIONS
      if @pin.user_uid != current_user.uid
        Notification.create!(
          user: @pin.user,
          actor: current_user,
          action: "commented on your post",
          notifiable: @comment,
          read: false
        )
      end

      if @comment.parent_id.present?
        parent_user = Comment.find(@comment.parent_id).user
        if parent_user.uid != current_user.uid && parent_user.uid != @pin.user_uid
          Notification.create!(
            user: parent_user,
            actor: current_user,
            action: "replied to your comment",
            notifiable: @comment,
            read: false
          )
        end
      end

      @pin.tagged_users.each do |tagged|
        next if tagged.id == current_user.id
        next if tagged.uid == @pin.user_uid

        Notification.create!(
          user: tagged,
          actor: current_user,
          action: "commented on a post you're tagged in",
          notifiable: @comment,
          read: false
        )
      end

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "pin_comments_#{@pin.id}",
            partial: "pins/comments",
            locals: { pin: @pin }
          )
        end

        format.html { redirect_to pin_path(@pin), notice: "Comment created." }
      end

    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "pin_comments_#{@pin.id}",
            partial: "pins/comments",
            locals: { pin: @pin }
          ), status: :unprocessable_entity
        end

        format.html { redirect_to pin_path(@pin), alert: @comment.errors.full_messages.join(", ") }
      end
    end
  end

  def destroy
    @comment.destroy if @comment.user == current_user

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "pin_comments_#{@pin.id}",
          partial: "pins/comments",
          locals: { pin: @pin }
        )
      end

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
