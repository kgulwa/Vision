class SavedPin < ApplicationRecord
  belongs_to :pin
  belongs_to :collection

  # A SavedPin does NOT directly belong to a user.
  # User comes through collection, so no belongs_to :user here.

  validates :pin_id, uniqueness: { scope: :collection_id }
end
