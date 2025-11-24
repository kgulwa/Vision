class SavedPin < ApplicationRecord
  self.primary_key = :uid

  def to_param
    uid
  end

  belongs_to :pin,        foreign_key: :pin_uid,        primary_key: :uid
  belongs_to :collection, foreign_key: :collection_uid, primary_key: :uid
  belongs_to :user,       foreign_key: :user_uid,        primary_key: :uid

  validates :pin_uid, uniqueness: { scope: :collection_uid }
end
