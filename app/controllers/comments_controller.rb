class CommentsController < ApplicationController
  before_action :require_login
  before_action :set_pin
  before_action :set_comment, only: [:edit, :update, :destroy]

 
  def new
    @comment = @pin.comments.build(parent_id: params[:parent_id])
  end


  def create
    @comment = @pin.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      notify_users(@comment)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to pin_path(@pin), notice: "Comment created." }
      end
    else
      respond_to do |format|
        format.turbo_stream { head :unprocessable_entity }
        format.html { redirect_to pin_path(@pin), alert: @comment.errors.full_messages.join(", ") }
      end
    end
  end


  def edit
    # rendered inside turbo-frame
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
    @comment.destroy if @comment && @comment.user == current_user

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to pin_path(@pin) }
    end
  end

 
  private

  def notify_users(comment)
    # Notify the pin owner
    if @pin.user_uid != current_user.uid
      Notification.create!(
        user: @pin.user,
        actor: current_user,
        action: "commented on your post",
        notifiable: comment,
        read: false
      )
    end

    # Notify parent comment owner
    if comment.parent_id.present?
      parent_user = Comment.find(comment.parent_id).user
      if parent_user.uid != current_user.uid && parent_user.uid != @pin.user_uid
        Notification.create!(
          user: parent_user,
          actor: current_user,
          action: "replied to your comment",
          notifiable: comment,
          read: false
        )
      end
    end

    # Notify tagged users
    @pin.tagged_users.each do |tagged|
      next if tagged.id == current_user.id
      next if tagged.uid == @pin.user_uid

      Notification.create!(
        user: tagged,
        actor: current_user,
        action: "commented on a post you're tagged in",
        notifiable: comment,
        read: false
      )
    end
  end

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
