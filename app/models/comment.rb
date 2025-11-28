class Comment < ApplicationRecord
  def to_param
    id
  end

  belongs_to :user, foreign_key: :user_id, optional: true
  belongs_to :pin, foreign_key: :pin_id

  validates :content, presence: true

  belongs_to :parent,
             class_name: "Comment",
             optional: true,
             foreign_key: :parent_id

  has_many :replies,
           class_name: "Comment",
           foreign_key: :parent_id,
           dependent: :destroy

  scope :from_existing_users, -> { where.not(user_id: nil) }
  scope :recent, -> { order(created_at: :desc) }

  # ⭐ Enables mention notifications
  after_create_commit :notify_mentioned_users

  private

  def notify_mentioned_users
    return if content.blank?

    # Find all unique usernames
    mentioned = content.scan(/@(\w+)/).flatten.uniq

    mentioned.each do |username|
      user = User.find_by(username: username)
      next if user.nil?
      next if user == self.user  # don't notify yourself

      Notification.create!(
        user: user,              # receiver
        actor: self.user,        # person who commented
        notifiable: self,        
        action: "mention",       
        read: false
      )
    end
  end
end
