class Comment < ApplicationRecord
  # Primary key is now :id automatically

  def to_param
    id
  end

  belongs_to :user, foreign_key: :user_id, optional: true
  belongs_to :pin, foreign_key: :pin_id

  validates :content, presence: true

  # Replies (self-join)
  belongs_to :parent,
             class_name: "Comment",
             optional: true,
             foreign_key: :parent_id

  has_many :replies,
           class_name: "Comment",
           foreign_key: :parent_id,
           dependent: :destroy

  # Scopes
  scope :from_existing_users, -> { where.not(user_id: nil) }
  scope :recent, -> { order(created_at: :desc) }
end
