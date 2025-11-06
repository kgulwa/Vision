class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :pin

  validates :content, presence: true

  scope :recent, -> { order(created_at: desc)}
end
