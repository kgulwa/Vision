class Repost < ApplicationRecord
  belongs_to :user
  belongs_to :pin, counter_cache: true


  validates :user_id, uniqueness: { scope: :pin_id }

end
