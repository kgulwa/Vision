class User < ApplicationRecord
  self.primary_key = :uid

  has_secure_password

  # Validations
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  # Normalize email to lowercase
  before_save :downcase_email

  # Associations with user_uid
  has_many :pins, foreign_key: :user_uid, primary_key: :uid, dependent: :destroy
  has_many :comments, foreign_key: :user_uid, primary_key: :uid, dependent: :destroy
  has_many :likes, foreign_key: :user_uid, primary_key: :uid, dependent: :destroy
  has_many :reposts, foreign_key: :user_uid, primary_key: :uid, dependent: :destroy

  has_many :liked_pins, through: :likes, source: :pin
  has_many :reposted_pins, through: :reposts, source: :pin

  # Following associations (UUIDs)
  has_many :active_follows, class_name: "Follow", foreign_key: :follower_uid, primary_key: :uid, dependent: :destroy
  has_many :passive_follows, class_name: "Follow", foreign_key: :followed_uid, primary_key: :uid, dependent: :destroy
  has_many :following, through: :active_follows, source: :followed
  has_many :followers, through: :passive_follows, source: :follower

  # Helper methods
  def follow(user); following << user unless self == user || following.include?(user); end
  def unfollow(user); following.delete(user); end
  def following?(user); following.include?(user); end
  def like(pin); liked_pins << pin unless liked_pins.include?(pin); end
  def unlike(pin); liked_pins.delete(pin); end
  def liked?(pin); liked_pins.include?(pin); end
  def repost(pin); reposted_pins << pin unless reposted_pins.include?(pin); end
  def unrepost(pin); reposted_pins.delete(pin); end
  def reposted?(pin); reposts.exists?(pin_id: pin.id); end

  private
  def downcase_email; self.email = email.downcase if email.present?; end
  def password_required?; password_digest.nil? || !password.blank?; end
end
