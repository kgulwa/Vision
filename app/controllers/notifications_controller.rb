class NotificationsController < ApplicationController
  before_action :require_login

  def index
    @notifications = current_user.notifications
                                .includes(:actor, :notifiable)
                                .order(created_at: :desc)

    # Mark all as read when viewed
    current_user.notifications.where(read: false).update_all(read: true)
  end
end
