class Pin < ApplicationRecord
  self.primary_key = :uid

  def to_param
    uid
  end
  

  belongs_to :user, foreign_key: :user_uid, primary_key: :uid, optional: true

  has_many :comments, foreign_key: :pin_uid, primary_key: :uid, dependent: :destroy
  has_many :likes, foreign_key: :pin_uid, primary_key: :uid, dependent: :destroy
  has_many :reposts, foreign_key: :pin_uid, primary_key: :uid, dependent: :destroy
  has_many :saved_pins, foreign_key: :pin_uid, primary_key: :uid, dependent: :destroy

  has_one_attached :image

  validates :title, presence: true

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :from_existing_users, -> { joins(:user) }

  # Count methods
  def comments_count
    comments.from_existing_users.count
  end

  def likes_count
    likes.count
  end

  def reposts_count
    reposts.count
  end
end
