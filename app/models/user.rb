class User < ApplicationRecord
  self.primary_key = :uid
  has_secure_password

  def to_param
    uid
  end
  

  # Validations
  validates :username, presence: true, uniqueness: { case_sensitive: true }
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  # Associations
  has_many :pins, foreign_key: :user_uid, primary_key: :uid, dependent: :destroy
  has_many :comments, foreign_key: :user_uid, primary_key: :uid, dependent: :destroy
  has_many :likes, foreign_key: :user_uid, primary_key: :uid, dependent: :destroy
  has_many :reposts, foreign_key: :user_uid, primary_key: :uid, dependent: :destroy
  has_many :collections, foreign_key: :user_uid, primary_key: :uid, dependent: :destroy
  has_many :saved_pins, foreign_key: :user_uid, primary_key: :uid, dependent: :destroy

  has_many :liked_pins, through: :likes, source: :pin
  has_many :reposted_pins, through: :reposts, source: :pin
  has_many :saved_pins_collections, through: :saved_pins, source: :collection

  # Following system
  has_many :active_follows, class_name: "Follow",
                           foreign_key: :follower_uid,
                           primary_key: :uid,
                           dependent: :destroy

  has_many :passive_follows, class_name: "Follow",
                            foreign_key: :followed_uid,
                            primary_key: :uid,
                            dependent: :destroy

  has_many :following, through: :active_follows, source: :followed
  has_many :followers, through: :passive_follows, source: :follower

  # Helper methods...
  def follow(user)
    following << user unless self == user || following.include?(user)
  end

  def unfollow(user)
    following.delete(user)
  end

  def following?(user)
    following.include?(user)
  end

  def like(pin)
    liked_pins << pin unless liked_pins.include?(pin)
  end

  def unlike(pin)
    liked_pins.delete(pin)
  end

  def liked?(pin)
    liked_pins.include?(pin)
  end

  def repost(pin)
    reposted_pins << pin unless reposted_pins.include?(pin)
  end

  def unrepost(pin)
    reposted_pins.delete(pin)
  end

  def reposted?(pin)
    reposts.exists?(pin_uid: pin.uid)
  end

  # Saved pins
  def save_pin(pin, collection_name = "Default")
    collection = collections.find_or_create_by(name: collection_name)
    saved_pins.find_or_create_by(pin_uid: pin.uid, collection_uid: collection.uid)
  end

  def unsave(pin)
    saved_pins.where(pin_uid: pin.uid).destroy_all
  end

  def saved?(pin)
    saved_pins.exists?(pin_uid: pin.uid)
  end

  private

  def password_required?
    password_digest.nil? || !password.blank?
  end
end
