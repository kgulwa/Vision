class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User", primary_key: :uid, foreign_key: :follower_uid
  belongs_to :followed, class_name: "User", primary_key: :uid, foreign_key: :followed_uid

  validates :follower_uid, uniqueness: { scope: :followed_uid }
  validate :cannot_follow_self

  private

  def cannot_follow_self
    errors.add(:follower_uid, "can't follow yourself") if follower_uid == followed_uid
  end
end
