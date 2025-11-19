class Comment < ApplicationRecord
  belongs_to :user, foreign_key: :user_uid, primary_key: :uid, optional: true
  belongs_to :pin
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy
  validates :content, presence: true
  scope :from_existing_users, -> { where.not(user_uid: nil) }
  scope :recent, -> { order(created_at: :desc) }
end
