class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User", foreign_key: :follower_id, primary_key: :id
  belongs_to :followed, class_name: "User", foreign_key: :followed_id, primary_key: :id

  validates :follower_id, presence: true
  validates :followed_id, presence: true
  validates :follower_id, uniqueness: { scope: :followed_id }

  validate :cannot_follow_self

  private

  def cannot_follow_self
    errors.add(:follower_id, "can't follow yourself") if follower_id == followed_id
  end
end
