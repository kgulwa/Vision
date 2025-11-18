class Pin < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  # Comments
  has_many :comments, dependent: :destroy

  # Likes
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  # Reposts
  has_many :reposts, dependent: :destroy
  has_many :reposted_by_users, through: :reposts, source: :user

  validates :title, presence: true
  validates :image, presence: true

  scope :recent, -> { order(created_at: :desc) }

  def likes_count
    likes.count
  end

  def reposts_count
    reposts.count
  end
end
