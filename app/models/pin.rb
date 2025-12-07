class Pin < ApplicationRecord
  def to_param
    id
  end

  # IMPORTANT: use user_uid + user's uid as PK
  belongs_to :user, foreign_key: :user_uid, primary_key: :uid

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :reposts, dependent: :destroy
  has_many :saved_pins, dependent: :destroy

  # TAGGING SYSTEM
  has_many :pin_tags, dependent: :destroy
  has_many :tagged_users, through: :pin_tags, source: :tagged_user

  # ONE FILE FOR IMAGES OR VIDEOS
  has_one_attached :file

  # BACKWARD COMPATIBILITY (Optional support for old image column)
  def image
    file if file&.image?
  end

  def video
    file if file&.video?
  end

  validates :title, presence: true
  validate :acceptable_file

  scope :recent, -> { order(created_at: :desc) }
  scope :from_existing_users, -> { joins(:user) }

  def likes_count
    likes.count
  end

  def comments_count
    comments.count
  end

  def acceptable_file
    return unless file.attached?

    # SIZE LIMIT
    if file.blob.byte_size > 50.megabytes
      errors.add(:file, "is too large. Max size is 50MB")
    end

    acceptable_types = [
      "image/png",
      "image/jpeg",
      "image/heic",
      "image/heif",
      "video/mp4",
      "video/quicktime"
    ]

    unless acceptable_types.include?(file.blob.content_type)
      errors.add(:file, "must be PNG, JPG, HEIC, MP4, or MOV")
    end
  end
end
