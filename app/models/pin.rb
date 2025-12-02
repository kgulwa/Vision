class Pin < ApplicationRecord
  def to_param
    id
  end

  belongs_to :user, foreign_key: :user_id

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :reposts, dependent: :destroy
  has_many :saved_pins, dependent: :destroy

  # TAGGING SYSTEM
  has_many :pin_tags, dependent: :destroy
  has_many :tagged_users, through: :pin_tags, source: :tagged_user

  has_one_attached :image

  validates :title, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :from_existing_users, -> { joins(:user) }
end
