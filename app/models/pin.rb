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

  # FILES
  has_one_attached :file      # image or video
  has_one_attached :thumbnail # custom or auto-generated thumbnail

  # Auto-generate thumbnail after video is attached
  after_commit :generate_default_thumbnail, on: [:create, :update]

  # Helpers
  def image
    file if file&.image?
  end

  def video
    file if file&.video?
  end

  def display_thumbnail
    thumbnail if thumbnail.attached?
  end

  # AUTO-GENERATE VIDEO THUMBNAIL
  def generate_default_thumbnail
    return unless file.attached? && file.video?
    return if thumbnail.attached? # user uploaded custom thumbnail

    begin
      # Temporary path
      temp_thumbnail = Rails.root.join("tmp", "video-thumb-#{id}.jpg")

      # Run FFmpeg to extract first frame at 1 second mark
      system(
        "ffmpeg -i #{ActiveStorage::Blob.service.send(:path_for, file.key)} " \
        "-ss 00:00:01 -vframes 1 #{temp_thumbnail} -y"
      )

      # Attach generated thumbnail
      if File.exist?(temp_thumbnail)
        thumbnail.attach(
          io: File.open(temp_thumbnail),
          filename: "thumbnail.jpg",
          content_type: "image/jpeg"
        )

        # Cleanup
        File.delete(temp_thumbnail) if File.exist?(temp_thumbnail)
      end

    rescue => e
      Rails.logger.error "❌ Failed to generate thumbnail: #{e.message}"
    end
  end

  # VALIDATIONS
  validates :title, presence: true
  validate :acceptable_file

  # SCOPES
  scope :recent, -> { order(created_at: :desc) }
  scope :from_existing_users, -> { joins(:user) }

  # COUNTERS
  def likes_count
    likes.count
  end

  def comments_count
    comments.count
  end

  # FILE VALIDATION
  def acceptable_file
    return unless file.attached?

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
