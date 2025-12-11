class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar

  # VALIDATIONS

  validates :uid, uniqueness: true
  validates :username,
            presence: true,
            uniqueness: { case_sensitive: true },
            on: :create

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP },
            on: :create

  validates :password, length: { minimum: 6 }, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?

  def password_required?
    new_record? || password.present?
  end

  # PIN SYSTEM
  has_many :pins,
           dependent: :destroy,
           foreign_key: :user_uid,
           primary_key: :uid

  has_many :saved_pins,
           dependent: :destroy,
           foreign_key: :user_id,
           primary_key: :id

  has_many :collections,
           dependent: :destroy,
           foreign_key: :user_id,
           primary_key: :id

  # COMMENTS
  has_many :comments,
           dependent: :destroy,
           foreign_key: :user_id,
           primary_key: :id

  # LIKES
  has_many :likes,
           dependent: :destroy,
           foreign_key: :user_id,
           primary_key: :id

  # REPOSTS
  has_many :reposts,
           dependent: :destroy,
           foreign_key: :user_id,
           primary_key: :id

  has_many :reposted_pins,
           through: :reposts,
           source: :pin

  # SEARCH HISTORY
  has_many :search_histories,
           dependent: :destroy,
           foreign_key: :user_id,
           primary_key: :id

  # FOLLOW SYSTEM
  has_many :follows,
           foreign_key: :follower_id,
           primary_key: :id,
           dependent: :destroy

  has_many :followings,
           through: :follows,
           source: :followed

  has_many :inverse_follows,
           class_name: "Follow",
           foreign_key: :followed_id,
           primary_key: :id,
           dependent: :destroy

  has_many :followers,
           through: :inverse_follows,
           source: :follower

  # NOTIFICATIONS
  has_many :notifications,
           dependent: :destroy,
           foreign_key: :user_id,
           primary_key: :id

  has_many :sent_notifications,
           class_name: "Notification",
           foreign_key: :actor_id,
           primary_key: :id,
           dependent: :destroy

  # TAGGING SYSTEM 
  has_many :pin_tags_as_tagged,
           class_name: "PinTag",
           foreign_key: :tagged_user_id,
           primary_key: :id,
           dependent: :destroy #delete tag when user account gets deleted

  has_many :pin_tags_as_author,
           class_name: "PinTag",
           foreign_key: :tagged_by_id,
           primary_key: :id,
           dependent: :destroy #delete tag when user account gets deleted

  has_many :tagged_pins,
           through: :pin_tags_as_tagged,
           source: :pin

  has_many :video_views, foreign_key: :user_uid, primary_key: :uid

  # METHODS
  def following?(other_user)
    followings.exists?(id: other_user.id)
  end

  def follow(other_user)
    follows.find_or_create_by(followed_id: other_user.id)
  end

  def unfollow(other_user)
    follows.where(followed_id: other_user.id).destroy_all
  end

  def liked?(pin)
    likes.exists?(pin_id: pin.id)
  end

  def like(pin)
    likes.find_or_create_by(pin_id: pin.id)
  end

  def unlike(pin)
    likes.where(pin_id: pin.id).destroy_all
  end

  def reposted?(pin)
    reposts.exists?(pin_id: pin.id)
  end

  def saved?(pin)
    saved_pins.exists?(pin_id: pin.id)
  end
end
