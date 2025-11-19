class Like < ApplicationRecord
  belongs_to :user, primary_key: :uid, foreign_key: :user_uid
  belongs_to :pin

  validates :user_uid, uniqueness: { scope: :pin_id }
end
