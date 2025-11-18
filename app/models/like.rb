class Like < ApplicationRecord
  belongs_to :user
  belongs_to :pin

  validates :user_id, uniqueness: { scope: :pin_id }
end