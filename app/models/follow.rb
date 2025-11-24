class Follow < ApplicationRecord
  self.primary_key = :uid

  def to_param
    uid
  end

  

  belongs_to :follower, class_name: "User",
                        foreign_key: :follower_uid,
                        primary_key: :uid

  belongs_to :followed, class_name: "User",
                        foreign_key: :followed_uid,
                        primary_key: :uid

  validates :follower_uid, presence: true
  validates :followed_uid, presence: true
  validates :follower_uid, uniqueness: { scope: :followed_uid }

  validate :cannot_follow_self

  private

  def cannot_follow_self
    errors.add(:follower_uid, "can't follow yourself") if follower_uid == followed_uid
  end
end
