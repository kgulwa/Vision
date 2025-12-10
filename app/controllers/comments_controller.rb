class CommentsController < ApplicationController
  before_action :require_login
  before_action :set_pin
  before_action :set_comment, only: [:edit, :update, :destroy]

  def new
    @comment = @pin.comments.new(parent_id: params[:parent_id])
  end

  def create
    @comment = @pin.comments.build(comment_params)
    @comment.user = current_user
    @comment.parent_id = params[:parent_id] if params[:parent_id]

    if @comment.save
      # Notify pin owner (unless commenting own pin)
      if @pin.user_uid != current_user.uid
        Notification.create!(
          user: @pin.user,
          actor: current_user,
          action: "commented on your post",
          notifiable: @comment,
          read: false
        )
      end

      # Notify parent owner if replying
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

      # Notify ALL tagged users (except actor + owner)
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
    @comment.destroy if @comment.user == current_user
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
