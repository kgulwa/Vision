class Pin < ApplicationRecord
  belongs_to :user, foreign_key: :user_uid, primary_key: :uid, optional: true
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :reposts, dependent: :destroy
  has_one_attached :image
  validates :title, presence: true
  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :from_existing_users, -> { joins(:user) }  # exclude pins with deleted users
  # Count methods
  def comments_count; comments.from_existing_users.count; end
  def likes_count; likes.count; end
  def reposts_count; reposts.count; end
end
