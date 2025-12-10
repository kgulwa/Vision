class Pin < ApplicationRecord
  def to_param
    id
  end

  
  belongs_to :user, foreign_key: :user_uid, primary_key: :uid

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :reposts, dependent: :destroy
  has_many :saved_pins, dependent: :destroy

  # TAGGING SYSTEM
  has_many :pin_tags, dependent: :destroy
  has_many :tagged_users, through: :pin_tags, source: :tagged_user

  has_one_attached :file #allows both images and videos
  has_one_attached :thumbnail #custom video thumbnail

  
  def image
    file if file&.image?
  end

  def video
    file if file&.video?
  end

  def display_thumbnail
    thumbnail if thumbnail.attached?
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

    acceptable_types = [ #acceptable types of files
      "image/png",
      "image/jpeg",
      "image/heic",
      "image/heif",
      "video/mp4",
      "video/quicktime"
    ]

    unless acceptable_types.include?(file.blob.content_type)
      errors.add(:file, "must be PNG, JPG, HEIC, MP4, or MOV") #error message incase of invalid file type
    end
  end
end
