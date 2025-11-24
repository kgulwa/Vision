class Collection < ApplicationRecord
  belongs_to :user

  has_many :saved_pins, dependent: :destroy
  has_many :pins, through: :saved_pins

  validates :name, presence: true
end
