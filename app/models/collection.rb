class Collection < ApplicationRecord
  belongs_to :user, foreign_key: :user_uid, primary_key: :uid
  has_many :saved_pins, dependent: :destroy
  has_many :pins, through: :saved_pins

  validates :name, presence: true
end
