module Notifications
  class MarkAllAsRead
    def self.call(user:)
      user.notifications.unread.update_all(read: true)
    end
  end
end
