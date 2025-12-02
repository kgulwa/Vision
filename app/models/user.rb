class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar

  
  # VALIDATIONS (FIXED)
  
  # Only validate username/email uniqueness on CREATE
  validates :username,
            presence: true,
            uniqueness: { case_sensitive: true },
            on: :create

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP },
            on: :create

  # Password validation only when needed
  validates :password, length: { minimum: 6 }, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?

  def password_required?
    new_record? || password.present?
  end

  
  # PIN SYSTEM
  
  has_many :pins, dependent: :destroy
  has_many :saved_pins, dependent: :destroy
  has_many :collections, dependent: :destroy

  # COMMENTS
  has_many :comments, dependent: :destroy

  # LIKES
  has_many :likes, dependent: :destroy

  # REPOSTS
  has_many :reposts, dependent: :destroy
  has_many :reposted_pins, through: :reposts, source: :pin

  # SEARCH HISTORY
  has_many :search_histories, dependent: :destroy

  
  # FOLLOW SYSTEM
  
  has_many :follows, foreign_key: :follower_id, dependent: :destroy
  has_many :followings, through: :follows, source: :followed

  has_many :inverse_follows,
           class_name: "Follow",
           foreign_key: :followed_id,
           dependent: :destroy
  has_many :followers, through: :inverse_follows, source: :follower

  
  # NOTIFICATIONS
  
  has_many :notifications, dependent: :destroy
  has_many :sent_notifications,
           class_name: "Notification",
           foreign_key: :actor_id,
           dependent: :destroy

  # ---------------------------------------
  # TAGGING SYSTEM
  # ---------------------------------------
  has_many :pin_tags, foreign_key: :tagged_user_id, dependent: :destroy
  has_many :tagged_pins, through: :pin_tags, source: :pin

  # ---------------------------------------
  # METHODS
  # ---------------------------------------
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
