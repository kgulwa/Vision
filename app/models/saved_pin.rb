class SavedPin < ApplicationRecord
  belongs_to :pin
  belongs_to :collection
  belongs_to :user

  validates :pin_id, uniqueness: { scope: :collection_id }
end
