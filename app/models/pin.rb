class Pin < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  # Comments association
  has_many :comments, dependent: :destroy

  # Likes association
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  validates :title, presence: true
  validates :image, presence: true

  scope :recent, -> { order(created_at: :desc) }

  # Helper method for likes count
  def likes_count
    likes.count
  end
end
