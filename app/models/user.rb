class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar

  #  PIN SYSTEM 
  has_many :pins, dependent: :nullify
  has_many :saved_pins, dependent: :destroy
  has_many :collections, dependent: :destroy

  #  COMMENTS 
  has_many :comments, dependent: :nullify

  #  LIKES 
  has_many :likes, dependent: :destroy

  #  REPOSTS 
  has_many :reposts, dependent: :destroy
  has_many :reposted_pins, through: :reposts, source: :pin

  #  SEARCH HISTORY 
  has_many :search_histories, dependent: :destroy

  #  FOLLOW SYSTEM 

  # People *I* follow
  has_many :follows, foreign_key: :follower_id, dependent: :destroy
  has_many :followings, through: :follows, source: :followed

  # People who follow *me*
  has_many :inverse_follows,
           class_name: "Follow",
           foreign_key: :followed_id,
           dependent: :destroy
  has_many :followers, through: :inverse_follows, source: :follower

  #  NOTIFICATIONS 

  # Notifications I *receive*
  has_many :notifications, dependent: :destroy

  # Notifications I *cause* (likes, follows, comments, mentions)
  has_many :sent_notifications,
           class_name: "Notification",
           foreign_key: :actor_id,
           dependent: :destroy

  #  METHODS 

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

  #  VALIDATIONS 
  validates :username, presence: true, uniqueness: { case_sensitive: true }

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  # Password validations
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :password, length: { minimum: 6 }, allow_blank: true, on: :update

  # 🔥 Proper confirmation validation
  validates :password_confirmation,
            presence: true,
            if: -> { password.present? }
end
