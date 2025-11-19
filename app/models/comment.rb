class Comment < ApplicationRecord
  self.primary_key = :uid

  belongs_to :user, primary_key: :uid, foreign_key: :user_uid
  belongs_to :pin

  validates :content, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
