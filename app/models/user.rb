class User < ApplicationRecord
  has_secure_password



  has_many :pins, dependent: :nullify
  has_many :collections, dependent: :destroy
  has_many :comments, dependent: :nullify
  has_many :likes, dependent: :destroy
  has_many :reposts, dependent: :destroy
  has_many :saved_pins, dependent: :destroy
  has_many :search_histories, dependent: :destroy


 
  # FOLLOW SYSTEM
  

  # People the user follows
  has_many :follows, foreign_key: :follower_id, dependent: :destroy
  has_many :followings, through: :follows, source: :followed

  # People who follow this user
  has_many :inverse_follows,
           class_name: "Follow",
           foreign_key: :followed_id,
           dependent: :destroy
  has_many :followers, through: :inverse_follows, source: :follower

  def following?(other_user)
    followings.exists?(id: other_user.id)
  end

  def follow(other_user)
    follows.find_or_create_by(followed_id: other_user.id)
  end

  def unfollow(other_user)
    follows.where(followed_id: other_user.id).destroy_all
  end

  
  # LIKE SYSTEM
  

  def liked?(pin)
    likes.exists?(pin_id: pin.id)
  end

  def like(pin)
    likes.find_or_create_by(pin_id: pin.id)
  end

  def unlike(pin)
    likes.where(pin_id: pin.id).destroy_all
  end

  
  # REPOST SYSTEM
  

  def reposted?(pin)
    reposts.exists?(pin_id: pin.id)
  end

  # These must be defined AFTER :reposts
  has_many :reposted_pins, through: :reposts, source: :pin

  
  # SAVED PINS SYSTEM
  

  def saved?(pin)
    saved_pins.exists?(pin_id: pin.id)
  end

 
  # VALIDATIONS
  

  validates :email, presence: true, uniqueness: true
end
