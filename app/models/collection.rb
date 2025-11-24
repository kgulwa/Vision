class Collection < ApplicationRecord
  self.primary_key = :uid

  def to_param
    uid
  end
  

  belongs_to :user, foreign_key: :user_uid, primary_key: :uid

  has_many :saved_pins, foreign_key: :collection_uid, primary_key: :uid, dependent: :destroy
  has_many :pins, through: :saved_pins

  validates :name, presence: true
end
