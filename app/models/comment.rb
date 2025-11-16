class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :pin

  validates :content, presence: true

  # Scope to get comments in reverse chronological order
  scope :recent, -> { order(created_at: :desc) }
end
