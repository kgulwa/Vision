class Like < ApplicationRecord
  self.primary_key = :uid

  def to_param
    uid
  end
  

  belongs_to :user, foreign_key: :user_uid, primary_key: :uid
  belongs_to :pin,  foreign_key: :pin_uid,  primary_key: :uid

  validates :user_uid, uniqueness: { scope: :pin_uid }
end
