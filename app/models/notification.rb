class Notification < ApplicationRecord
  belongs_to :user                    # receiver
  belongs_to :actor, class_name: "User"  # who triggered the event
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read: false) }

  def actor_username
    actor.username
  end
end
