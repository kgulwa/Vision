class Pin < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  # Likes association
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  validates :title, presence: true
  validates :image, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
