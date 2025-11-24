class Comment < ApplicationRecord
  self.primary_key = :uid

  def to_param
    uid
  end
  

  belongs_to :user, foreign_key: :user_uid, primary_key: :uid, optional: true
  belongs_to :pin, foreign_key: :pin_uid, primary_key: :uid

  validates :content, presence: true

  # Replies
  belongs_to :parent, class_name: "Comment",
                      optional: true,
                      foreign_key: :parent_uid,
                      primary_key: :uid

  has_many :replies, class_name: "Comment",
                     foreign_key: :parent_uid,
                     primary_key: :uid,
                     dependent: :destroy

  scope :from_existing_users, -> { where.not(user_uid: nil) }
  scope :recent, -> { order(created_at: :desc) }
end
