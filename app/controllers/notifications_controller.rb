class NotificationsController < ApplicationController
  before_action :require_login

  def index
    @notifications = current_user.notifications
                                 .includes(:actor, :notifiable)
                                 .order(created_at: :desc)

    Notifications::MarkAllAsRead.call(user: current_user)
  end
end
