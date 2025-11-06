class User < ApplicationRecord
    has_secure_password

    # validations
    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

    # associations
    has_many :pins, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :likes, dependent: :destroy
    has_many :reposts, dependent: :destroy
    has_many :liked_pins, through: :likes, source: :pin
    has_many :reposted_pins, through: :reposts, source: :pin 

    # following associations
    has_many :active_follows, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
    has_many :passive_follows, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy
    has_many :following, through: :active_follows, source: :followed
    has_many :followers, through: :passive_follows, source: :follower

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
        reposted_pins.include?(pin)
    end
end
