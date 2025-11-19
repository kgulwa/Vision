class Pin < ApplicationRecord
  belongs_to :user, primary_key: :uid, foreign_key: :user_uid
  has_one_attached :image

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user
  has_many :reposts, dependent: :destroy
  has_many :reposted_by_users, through: :reposts, source: :user

  validates :title, presence: true
  validates :image, presence: true

  scope :recent, -> { order(created_at: :desc) }

  # Count methods
  def comments_count
    comments.count
  end

  def likes_count
    likes.count
  end

  def reposts_count
    reposts.count
  end
end
